# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit cmake git-r3 linux-info python-single-r1 systemd udev

DESCRIPTION="Run Android applications on any GNU/Linux operating system"
HOMEPAGE="https://anbox.io/"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
IMG_PATH="$(ver_cut 2)/$(ver_cut 3)/$(ver_cut 4)"
SRC_URI="https://build.anbox.io/android-images/${IMG_PATH}/android_amd64.img
	playstore? ( http://dl.android-x86.org/houdini/7_y/houdini.sfs -> houdini_y.sfs
			http://dl.android-x86.org/houdini/7_z/houdini.sfs -> houdini_z.sfs )"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+playstore privileged softrender test wayland +X"
REQUIRED_USE="|| ( wayland X )"
RESTRICT="mirror"

## Anbox makes use of LXC containers ##
# File and directory permissions are set by LXC as either a 'privileged' or 'unprivileged' container #
# For fperms to be correct inside the Anbox container, LXC must start the container as 'unprivileged' #
#  Otherwise fperms will appear corrupt as 'u1_<uid>' and 'u1_<gid>' #
# LXC hardcodes the use of sys-apps/shadow 'newuidmap' and 'newgidmap' (if they exist on the host) to map UID/GID from host to container #
#	Anbox usually runs confined inside a 'snap' environment, so relies on LXC not detecting 'newuidmap' and 'newgidmap' on the host system, #
#		leading to LXC then falling through to directly setup UID/GID mapping itself #
#			 eliminating the need for correct setup of /etc/subuid and /etc/subgid files #
# DEBUGGING:
#	LXC tools can be used to test the container:
#		lxc-start -P /var/lib/anbox/containers/ -n default -F
#		lxc-info -P /var/lib/anbox/containers/ -n default
#		lxc-stop -P /var/lib/anbox/containers/ -n default
#	/var/lib/anbox/containers/default/default.log	# LXC container log
#	/var/lib/anbox/rootfs/data/system.log		# Android system log
#	ANBOX_LOG_LEVEL=debug anbox session-manager
##
# anbox-container-manager.service does the following:
#	Sets up cgroups and mounts /var/lib/anbox/android.img on LXC path /var/lib/anbox/rootfs/
#	Bind mounts as desktop user	/var/lib/anbox/cache on /var/lib/anbox/rootfs/cache
#					/var/lib/anbox/data on /var/lib/anbox/rootfs/data
# anbox.desktop automatically starts 'anbox session-manger' and launches the windowed Android Application Manager
#
# 'anbox session-manager' sets up LXC container config and writes it out to /var/lib/anbox/containers/default/config
#
# Anbox does not use LXC to set the container gateway but instead has 'anbox container-manager' write the gateway info
#  to the Android system '/data/misc/ethernet/ipconfig.txt' file and relies on Android /system/etc/init/netd.rc service to read and set the gateway routing on boot
##

RDEPEND="dev-util/android-tools
	net-firewall/iptables
	softrender? ( media-libs/swiftshader )"
DEPEND="${RDEPEND}
	>=app-containers/lxc-3
	dev-cpp/gtest
	dev-libs/boost:=
	dev-libs/glib:2
	dev-libs/properties-cpp
	dev-libs/protobuf
	media-libs/glm
	media-libs/libsdl2[wayland?,X?]
	>=media-libs/mesa-19.3.5[gles2]
	media-libs/sdl2-image
	sys-apps/dbus
	sys-libs/libcap
	sys-apps/systemd[iptables]
	playstore? ( app-arch/lzip
			app-arch/tar
			app-arch/unzip
			net-misc/curl
			sys-fs/squashfs-tools )
	test? ( >=dev-cpp/gtest-1.8.1 )"

CONFIG_CHECK="
	~ANDROID_BINDER_IPC
	~ASHMEM
	~BINFMT_MISC
	~BRIDGE
	~IP_MROUTE_MULTIPLE_TABLES
	~IP_NF_IPTABLES
	~IP_NF_MANGLE
	~IP_NF_NAT
	~IP6_NF_NAT
	~IP6_NF_TARGET_MASQUERADE
	~IPC_NS
	~IPV6_MULTIPLE_TABLES
	~IPV6_MROUTE
	~NAMESPACES
	~NET_KEY
	~NET_NS
	~NETLINK_DIAG
	~NF_NAT_MASQUERADE
	~NF_SOCKET_IPV4
	~NF_SOCKET_IPV6
	~PACKET_DIAG
	~PID_NS
	~SQUASHFS
	~SQUASHFS_XZ
	~TUN
	~USER_NS
	~UTS_NS
	~VETH
"

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	# Set a default path to Swiftshader libs (can still be overridden with 'SWIFTSHADER_PATH' env variable) #
	sed -e 's/utils::get_env_value("SWIFTSHADER_PATH"/utils::get_env_value("SWIFTSHADER_PATH", "\/usr\/lib\/swiftshader"/' \
		-i src/anbox/graphics/gl_renderer_server.cpp
	! use test && \
		truncate -s0 cmake/FindGMock.cmake tests/CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_WAYLAND="$(usex wayland)"
		-DENABLE_X11="$(usex X)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# 'anbox-container-manager.service' is started as root #
	insinto $(systemd_get_systemunitdir)
	doins "${FILESDIR}/anbox-container-manager.service"

	## '+privileged' not recommended as permissions are corrupted (see above notes) - causes 'su' to fail in 'adb shell' ##
	use privileged && \
		sed -e 's:--daemon --data-path:--daemon --privileged --data-path:g' \
			-i "${ED}/$(systemd_get_systemunitdir)/anbox-container-manager.service"

	dosym $(systemd_get_systemunitdir)/anbox-container-manager.service \
		$(systemd_get_systemunitdir)/default.target.wants/anbox-container-manager.service

	# 'anbox0' network interface #
	insinto $(systemd_get_utildir)/network
	doins "${FILESDIR}/80-anbox-bridge.network"
	doins "${FILESDIR}/80-anbox-bridge.netdev"
	dosym $(systemd_get_systemunitdir)/systemd-networkd.service \
		$(systemd_get_systemunitdir)/default.target.wants/systemd-networkd.service

	# 'anbox-launch' wrapper script to start 'session-manager' and anbox appmgr #
	exeinto /usr/bin
	doexe "${FILESDIR}/anbox-launch"

	# anbox.desktop and icon #
	insinto /usr/share/applications
	doins "${FILESDIR}/anbox.desktop"
	insinto /usr/share/pixmaps
	newins snap/gui/icon.png anbox.png

	insinto /var/lib/anbox
	if use playstore; then
		doins "${DISTDIR}/houdini_y.sfs"
		doins "${DISTDIR}/houdini_z.sfs"
	fi
	doins "${FILESDIR}/media_codecs.xml"
	doins "${DISTDIR}/android_amd64.img"
	# anbox-container-manager.service defaults to use android.img #
	dosym /var/lib/anbox/android_amd64.img /var/lib/anbox/android.img

	udev_dorules "${FILESDIR}/99-anbox.rules"
	dodoc README.md COPYING.GPL AUTHORS docs/*
}

pkg_postinst() {
	if ! use privileged; then
		if [ ! -s /etc/subuid ] || [ ! -s /etc/subgid ] && [ -e /usr/bin/newuidmap ]; then
			elog
			elog "Oops...$(which newuidmap) and $(which newgidmap) have been detected, but no /etc/subuid or /etc/subgid files have been detected on the system"
			elog "LXC container user support (unprivileged) needs to map UIDs/GIDs from the host to the container"
			elog "By default LXC does so using sys-apps/shadow's 'newuidmap' and 'newgidmap' applications configured by /etc/subuid and /etc/subgid"
			elog " which can sometimes be quite complex to setup, particularly on multi-user systems (YMMV)"
			elog "The preferred method is to make 'newuidmap' and 'newgidmap' inaccessible to LXC"
			elog " This forces LXC to more robustly handle the UID/GID host<->container mapping itself"
			elog " Anbox make them inaccessible on their preferred Ubuntu platform by running inside a SNAP environment"
			elog " On Gentoo we can do the following (as root):"
			elog "   # echo 'EXTRA_ECONF=\"--enable-subordinate-ids=no\"' >> /etc/portage/env/remove-newsuidmap"
			elog "   # echo 'sys-apps/shadow remove-newsuidmap' >> /etc/portage/package.env/sys-apps_shadow-remove-newsuidmap"
			elog "   # emerge -1 sys-apps/shadow"
			elog " NB: This method will remove 'newuidmap' and 'newgidmap', so if you need those to be present"
			elog "  for other purposes, then you'll need to manage the /etc/subuid and /etc/subgid method"
		fi
	fi

        elog
        elog "To run Anbox, as root:"
        elog " # systemctl start anbox-container-manager"
	if linux_chkconfig_present ANDROID_BINDERFS; then
		elog " # mkdir /dev/binderfs"
		elog " # mount -t binder none /dev/binderfs"
		elog " #	OR place the entry into /etc/fstab"
		elog " # binderfs    /dev/binderfs    binder    defaults    0 0"
	fi
        elog "Then as desktop user:"
        elog " $ anbox session-manager --gles-driver=host"
        elog " $ anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity"
	if use softrender; then
	        elog "To run Anbox using software rendering, run 'session-manager' as follows, as desktop user:"
	        elog " $ ANBOX_FORCE_SOFTWARE_RENDERING=true anbox session-manager --gles-driver=host"
	fi
        elog
        elog "To install APKs: 'adb install myapp.apk'"
        elog "To copy files: 'adb push somefile /sdcard'"
        elog
        elog "If clicking on an installed app inside Anbox doesn't display it's window,"
        elog " you may need to instead run Anbox in 'Single Window Mode', example:"
        elog " $ anbox session-manager --gles-driver=host --single-window --window-size=1024,768"
	elog
	elog "When trying to run the stock Android Music app it will crash"
	elog " This is due to https://github.com/anbox/anbox/issues/68"
	elog " Solution: Install another Music player from Google's Playstore"

	if use playstore; then
		elog
		elog "To install Google Playstore and ARM app support, close any instances of Anbox and execute:"
		elog "  emerge --config =${CATEGORY}/${PF}"
		elog "  This will download and install the latest GoogleApps into Anbox's default android.img"
		elog
		elog "Please note that Anbox only supports GLESv1/GLESv2"
		elog "As more Playstore apps/games move up to GLESv3 they may no longer work until Anbox starts supporting GLESv3"
		elog " (see https://github.com/anbox/anbox/issues/246)"
	fi
}

pkg_config() {
	## Inspired by https://geeks-r-us.de/2017/08/26/android-apps-auf-dem-linux-desktop/ ##
	# Setup env and download latest GoogleApps #
	REAUTHDIR="/tmp/anbox-reauth"
	rm -rf "${REAUTHDIR}" &> /dev/null
	mkdir "${REAUTHDIR}" && cd "${REAUTHDIR}" || die
	local OPENGAPPS_RELEASEDATE="$(curl -s https://api.github.com/repos/opengapps/x86_64/releases/latest | head -n 10 | grep tag_name | grep -o "\"[0-9][0-9]*\"" | grep -o "[0-9]*")"
	wget "https://sourceforge.net/projects/opengapps/files/x86_64/${OPENGAPPS_RELEASEDATE}/open_gapps-x86_64-7.1-mini-${OPENGAPPS_RELEASEDATE}.zip" || die

	# Exract Anbox.img #
	unsquashfs /var/lib/anbox/android_amd64.img || die

	# Extract and copy OpenGapps APK files to Anbox.img #
	unzip -d opengapps open_gapps-x86_64-7.1-mini-${OPENGAPPS_RELEASEDATE}.zip || die
	pushd opengapps/Core/
		for filename in *.tar.lz; do
			tar --lzip -xvf "${filename}"
		done
	popd
	APPDIR="squashfs-root/system/priv-app"
	cp -r $(find opengapps -type d -name "PrebuiltGmsCore") ${APPDIR}
	cp -r $(find opengapps -type d -name "GoogleLoginService") ${APPDIR}
	cp -r $(find opengapps -type d -name "Phonesky") ${APPDIR}
	cp -r $(find opengapps -type d -name "GoogleServicesFramework") ${APPDIR}
	pushd "${APPDIR}"
		chown -R 100000:100000 Phonesky GoogleLoginService GoogleServicesFramework PrebuiltGmsCore || die
	popd

	# Extract and copy 32-bit houdini_y to Anbox.img #
	unsquashfs -d houdini_y /var/lib/anbox/houdini_y.sfs || die
	LIBDIR="squashfs-root/system/lib"
	mkdir -p "${LIBDIR}/arm"
	cp -r houdini_y/* "${LIBDIR}/arm"
	chown -R 100000:100000 "${LIBDIR}/arm"
	mv "${LIBDIR}/arm/libhoudini.so" "${LIBDIR}/libhoudini.so"

	# Extract and copy 64-bit houdini_z to Anbox.img #
	unsquashfs -d houdini_z /var/lib/anbox/houdini_z.sfs || die
	LIBDIR64="squashfs-root/system/lib64"
	mkdir -p "${LIBDIR64}/arm64"
	cp -r houdini_z/* "${LIBDIR64}/arm64"
	chown -R 100000:100000 "${LIBDIR64}/arm64"
	mv "${LIBDIR64}/arm64/libhoudini.so" "${LIBDIR64}/libhoudini.so"

	# Add houdini parser (needs to be done outside portage sandbox) #
	BINFMT_DIR="/proc/sys/fs/binfmt_misc/register"
	echo ':arm_exe:M::\x7f\x45\x4c\x46\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28::/system/lib/arm/houdini:P' | tee -a "$BINFMT_DIR"
	echo ':arm_dyn:M::\x7f\x45\x4c\x46\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x28::/system/lib/arm/houdini:P' | tee -a "$BINFMT_DIR"
	echo ':arm64_exe:M::\x7f\x45\x4c\x46\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7::/system/lib64/arm64/houdini64:P' | tee -a "$BINFMT_DIR"
	echo ':arm64_dyn:M::\x7f\x45\x4c\x46\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\xb7::/system/lib64/arm64/houdini64:P' | tee -a "$BINFMT_DIR"

	# Enable features #
C=$(cat <<-END
  <feature name="android.hardware.touchscreen" />\n
  <feature name="android.hardware.audio.output" />\n
  <feature name="android.hardware.camera" />\n
  <feature name="android.hardware.camera.any" />\n
  <feature name="android.hardware.location" />\n
  <feature name="android.hardware.location.gps" />\n
  <feature name="android.hardware.location.network" />\n
  <feature name="android.hardware.microphone" />\n
  <feature name="android.hardware.screen.portrait" />\n
  <feature name="android.hardware.screen.landscape" />\n
  <feature name="android.hardware.wifi" />\n
  <feature name="android.hardware.bluetooth" />"
END
)
	C=$(echo $C | sed 's/\//\\\//g')
	C=$(echo $C | sed 's/\"/\\\"/g')

	sed -i "/<\/permissions>/ s/.*/${C}\n&/" "squashfs-root/system/etc/permissions/anbox.xml"

	# Enable wifi and bluetooth #
	sed -i "/<unavailable-feature name=\"android.hardware.wifi\" \/>/d" "squashfs-root/system/etc/permissions/anbox.xml"
	sed -i "/<unavailable-feature name=\"android.hardware.bluetooth\" \/>/d" "squashfs-root/system/etc/permissions/anbox.xml"

	# Set processors #
	sed -i "/^ro.product.cpu.abilist=x86_64,x86/ s/$/,armeabi-v7a,armeabi,arm64-v8a/" "squashfs-root/system/build.prop"
	sed -i "/^ro.product.cpu.abilist32=x86/ s/$/,armeabi-v7a,armeabi/" "squashfs-root/system/build.prop"
	sed -i "/^ro.product.cpu.abilist64=x86_64/ s/$/,arm64-v8a/" "squashfs-root/system/build.prop"

	echo "persist.sys.nativebridge=1" | tee -a "squashfs-root/system/build.prop"
	sed -i '/ro.zygote=zygote64_32/a\ro.dalvik.vm.native.bridge=libhoudini.so' "squashfs-root/default.prop"

	# Enable OpenGLES #
	echo "ro.opengles.version=131072" | tee -a "squashfs-root/system/build.prop"

	# Fix absent audio by exposing media codecs #
	cp "/var/lib/anbox/media_codecs.xml" "squashfs-root/system/etc/"

	# Re-author modified android.img #
	mksquashfs squashfs-root "${REAUTHDIR}/android_playstore.img" -b 131072 -comp xz -Xbcj x86 || die
	mv "${REAUTHDIR}/android_playstore.img" /var/lib/anbox/ || die
	rm /var/lib/anbox/android.img &> /dev/null
	ln -s /var/lib/anbox/android_playstore.img /var/lib/anbox/android.img
	elog
	elog "Success! New GoogleApps + ARM enabled image has been installed at /var/lib/anbox/android.img"
	elog "If 'anbox-container-manager.service' is already running, it will need restarting to reload the new android.img"
	elog
	elog "Problem: Google Playstore won't let me login"
	elog "Solution: Connect to running Anbox Android system and issue the following:"
	elog " $ adb shell"
	elog " $ pm grant com.google.android.gms android.permission.ACCESS_FINE_LOCATION"
}
