# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python3_4 )
DISTUTILS_SINGLE_IMPL=1

URELEASE="zesty"
inherit cmake-utils distutils-r1 eutils gnome2-utils pam systemd toolchain-funcs ubuntu-versionator xdummy

UURL="mirror://unity/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="The Ubuntu Unity Desktop"
HOMEPAGE="https://launchpad.net/unity"

SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="+branding debug doc pch +systray test"
RESTRICT="mirror"

S="${WORKDIR}"

RDEPEND=">=sys-apps/systemd-232
	sys-auth/polkit-pkla-compat
	unity-base/gsettings-ubuntu-touch-schemas
	unity-base/session-shortcuts
	unity-base/unity-language-pack
	x11-themes/humanity-icon-theme
	x11-themes/gtk-engines-murrine
	x11-themes/unity-asset-pool"
DEPEND="${RDEPEND}
	!unity-base/dconf-qt
	dev-libs/boost:=
	dev-libs/dee:=
	dev-libs/dbus-glib
	dev-libs/icu:=
	dev-libs/libappindicator
	dev-libs/libdbusmenu:=
	dev-libs/libffi
	dev-libs/libindicate[gtk,introspection]
	dev-libs/libindicate-qt
	dev-libs/libindicator
	dev-libs/libsigc++:2
	dev-libs/libunity
	dev-libs/libunity-misc:=
	dev-libs/xpathselect
	dev-python/gconf-python
	gnome-base/gconf
	app-text/yelp-tools
	gnome-base/gnome-desktop:3=
	gnome-base/gnome-menus:3
	gnome-base/gnome-session[systemd]
	gnome-base/gsettings-desktop-schemas
	gnome-extra/polkit-gnome:0
	media-libs/clutter-gtk:1.0
	media-libs/glew:=
	sys-apps/dbus[systemd,user-session]
	sys-apps/upstart
	sys-auth/pambase
	sys-libs/libnih[dbus]
	unity-base/bamf:=
	unity-base/compiz:=
	unity-base/nux:=[debug?]
	unity-base/overlay-scrollbar
	unity-base/unity-control-center
	unity-base/unity-settings-daemon
	x11-base/xorg-server[dmx]
	>=x11-libs/cairo-1.13.1
	x11-libs/libXfixes
	x11-libs/startup-notification
	unity-base/unity-gtk-module
	virtual/pam
	x11-misc/appmenu-qt
	x11-misc/appmenu-qt5
	doc? ( app-doc/doxygen )
	test? ( dev-cpp/gmock
		dev-cpp/gtest
		dev-python/autopilot
		dev-util/dbus-test-runner
		sys-apps/xorg-gtest )"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	if use test; then
		## Disable source trying to run it's own dummy-xorg-test-runner.sh script ##
		sed -e 's:set (DUMMY_XORG_TEST_RUNNER.*:set (DUMMY_XORG_TEST_RUNNER /bin/true):g' \
			-i tests/CMakeLists.txt
	fi
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"	# This needs to be applied for the debian/ directory to be present #
	ubuntu-versionator_src_prepare

	# Taken from http://ppa.launchpad.net/timekiller/unity-systrayfix/ubuntu/pool/main/u/unity/ #
	if use systray; then
		epatch -p1 "${FILESDIR}/systray-fix_saucy.diff"
	fi

	# Setup Unity side launcher default applications #
	sed \
		-e '/amazon/d' \
		-e '/software-center/d' \
		-e 's:nautilus.desktop:org.gnome.Nautilus.desktop:' \
			-i data/com.canonical.Unity.gschema.xml || die

	sed -e "s:/desktop:/org/unity/desktop:g" \
		-i data/com.canonical.Unity.gschema.xml || die

	sed -e "s:Ubuntu Desktop:Unity Gentoo Desktop:g" \
		-i panel/PanelMenuView.cpp || die

	# Remove testsuite cmake installation #
	sed -e '/setup.py install/d' \
			-i tests/CMakeLists.txt || die "Sed failed for tests/CMakeLists.txt"

	# Unset CMAKE_BUILD_TYPE env variable so that cmake-utils.eclass doesn't try to 'append-cppflags -DNDEBUG' #
	#       resulting in build failure with 'fatal error: unitycore_pch.hh: No such file or directory' #
	export CMAKE_BUILD_TYPE=none

	# Disable '-Werror'
	sed -i 's/[ ]*-Werror[ ]*//g' CMakeLists.txt services/CMakeLists.txt

	# Support use of the /usr/bin/unity python script #
	sed \
		-e 's:.*"stop", "unity-panel-service".*:        subprocess.call(["pkill -e unity-panel-service"], shell=True):' \
		-e 's:.*"start", "unity-panel-service".*:        subprocess.call(["/usr/lib/unity/unity-panel-service"], shell=True):' \
			-i tools/unity.cmake || die "Sed failed for tools/unity.cmake"

	# Don't kill -9 unity-panel-service when launched using PANEL_USE_LOCAL_SERVICE env variable #
	#  It slows down the launch of unity-panel-service in lockscreen mode #
	sed -e '/killall -9 unity-panel-service/,+1d' \
		-i UnityCore/DBusIndicators.cpp || die "Sed failed for UnityCore/DBusIndicators.cpp"

	# Include directly iostream needed for std::cout #
	sed -e 's/.*<fstream>.*/#include <iostream>\n&/' \
		-i unity-shared/DebugDBusInterface.cpp || die "Sed failed for unity-shared/DebugDBusInterface.cpp"

	# DESKTOP_SESSION and SESSION is 'unity' not 'ubuntu' #
	sed -e 's:SESSION=ubuntu:SESSION=unity:g' \
		-e 's:ubuntu-session:unity-session:g' \
			-i {data/unity7.conf.in,data/unity7.service.in,services/unity-panel-service.conf.in} || \
				die "Sed failed for {data/unity7.conf.in,services/unity-panel-service.conf.in}"
	sed -e 's:ubuntu.session:unity.session:g' \
		-i tools/{systemd,upstart}-prestart-check || \
			die "Sed failed for tools/{systemd,upstart}-prestart-check"

	# 'After=graphical-session-pre.target' must be explicitly set in the unit files that require it #
	# Relying on the upstart job /usr/share/upstart/systemd-session/upstart/systemd-graphical-session.conf #
	#	to create "$XDG_RUNTIME_DIR/systemd/user/${unit}.d/graphical-session-pre.conf" drop-in units #
	#	results in weird race problems on desktop logout where the reliant desktop services #
	#	stop in a different jumbled order each time #
	sed -e 's:Requires=unity-settings-daemon.service:Requires=gnome-session.service unity-settings-daemon.service:g' \
		-e 's:After=unity-settings-daemon.service:After=graphical-session-pre.target gnome-session.service bamfdaemon.service unity-settings-daemon.service:g' \
			-i data/unity7.service.in || \
				die "Sed failed for data/unity7.service.in"

	# Fix build error: ‘std::vector’ has not been declared #
	epatch -p1 "${FILESDIR}/unity-7.5.0_fix-missing-vector-includes.diff"

	cmake-utils_src_prepare
}

src_configure() {
	if use test; then
		mycmakeargs+=(-DBUILD_XORG_GTEST=ON
			-DCOMPIZ_BUILD_TESTING=ON
			-DENABLE_UNIT_TESTS=ON)
	else
		mycmakeargs+=(-DBUILD_XORG_GTEST=OFF
			-DCOMPIZ_BUILD_TESTING=OFF
			-DENABLE_UNIT_TESTS=OFF)
	fi

	if use pch; then
		mycmakeargs+=(-Duse_pch=ON)
	else
		mycmakeargs+=(-Duse_pch=OFF)
	fi

	mycmakeargs+=(-DCOMPIZ_BUILD_WITH_RPATH=FALSE
		-DCOMPIZ_PACKAGING_ENABLED=TRUE
		-DCOMPIZ_PLUGIN_INSTALL_TYPE=package
		-DCOMPIZ_INSTALL_GCONF_SCHEMA_DIR=/etc/gconf/schemas
		-DUSE_GSETTINGS=TRUE
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_SYSCONFDIR=/etc)
	cmake-utils_src_configure || die
}

src_compile() {
	if use test; then
		pushd tests/autopilot
			distutils-r1_src_compile
		popd
	fi

	# 'make translations' is sometimes not parallel make safe #
	pushd ${CMAKE_BUILD_DIR}
		emake -j1 translations
	popd
	cmake-utils_src_compile || die
}

src_test() {
	pushd ${CMAKE_BUILD_DIR}
		local XDUMMY_COMMAND="make check-headless"
		xdummymake
	popd
}

src_install() {
	pushd ${CMAKE_BUILD_DIR}
		addpredict /usr/share/glib-2.0/schemas/	# FIXME
		emake DESTDIR="${D}" install
	popd

	if use debug; then
		exeinto /etc/X11/xinit/xinitrc.d/
		doexe "${FILESDIR}/99unity-debug"
	fi

	if use test; then
		pushd tests/autopilot
			distutils-r1_src_install
		popd
	fi

	python_fix_shebang "${ED}"

	# Gentoo dash launcher icon #
	if use branding; then
		insinto /usr/share/unity/icons
		doins "${FILESDIR}/launcher_bfb.png"
		doins "${FILESDIR}/cof.png"

		# Gentoo logo on lock-srceen on multi head system
                newins "${FILESDIR}/cof.png" lockscreen_cof.png

	fi

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"

	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/99ibus-service"

	# ibus-daemon start is provided #
	#  by /etc/xdg/autostart/ibus-daemon.desktop #
	#  due to issue #156 #
	insinto /etc/xdg/autostart/
	doins "${FILESDIR}/ibus-daemon.desktop"

	# Allow zeitgeist-fts to find KDE *.desktop files, so that KDE applications show in Dash 'Recently Used' (see LP# 1251915) #
	#  (refer https://developer.gnome.org/gio/stable/gio-Desktop-file-based-GAppInfo.html#g-desktop-app-info-new)
	#	This has the unwanted side effect of creating duplicate entries for KDE applications in the Search and Applications lense #
	dosym /usr/share/applications/kde4/ /usr/share/kde4/applications
	insinto /etc/X11/xinit/xinitrc.d
	doins "${FILESDIR}/15-xdg-data-kde"

	# Clean up pam file installation as used in lockscreen (LP# 1305440) #
	rm -rf "${ED}usr/etc/pam.d"
	pamd_mimic system-local-login ${PN} auth account session

	# Set base desktop user privileges #
	insinto /var/lib/polkit-1/localauthority/10-vendor.d
	doins "${FILESDIR}/com.ubuntu.desktop.pkla"
	fowners root:polkitd /var/lib/polkit-1/localauthority/10-vendor.d/com.ubuntu.desktop.pkla

	# Make 'unity-session.target' systemd user unit auto-start 'unity7.service' #
	dosym $(systemd_get_userunitdir)/unity7.service $(systemd_get_userunitdir)/unity-session.target.requires/unity7.service
	dosym $(systemd_get_userunitdir)/unity-gtk-module.service $(systemd_get_userunitdir)/unity-session.target.wants/unity-gtk-module.service
	dosym $(systemd_get_userunitdir)/unity-settings-daemon.service $(systemd_get_userunitdir)/unity-session.target.wants/unity-settings-daemon.service

	# Top panel systemd indicator services required for unity-panel-service #
	for each in {application,bluetooth,datetime,keyboard,messages,power,printers,session,sound}; do
		dosym $(systemd_get_userunitdir)/indicator-${each}.service $(systemd_get_userunitdir)/unity-panel-service.service.wants/indicator-${each}.service
	done

	# Top panel systemd indicator services required for unity-panel-service-lockscreen #
	for each in {datetime,keyboard,power,session,sound}; do
		dosym $(systemd_get_userunitdir)/indicator-${each}.service $(systemd_get_userunitdir)/unity-panel-service-lockscreen.service.wants/indicator-${each}.service
	done
}

pkg_preinst() {
        gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	elog "If you use a custom ~/.xinitrc to startx"
	elog "then you should add the following to the top of your ~/.xinitrc file"
	elog "to ensure all needed services are started:"
	elog ' XSESSION=unity'
	elog ' if [ -d /etc/X11/xinit/xinitrc.d ] ; then'
	elog '   for f in /etc/X11/xinit/xinitrc.d/* ; do'
	elog '     [ -x "$f" ] && . "$f"'
	elog '   done'
	elog ' unset f'
	elog ' fi'
	elog
	elog "It is recommended to enable the 'ayatana' USE flag"
	elog "for portage packages so they can use the Unity"
	elog "libindicate or libappindicator notification plugins"
	elog
	elog "If you would like to use Unity's icons and themes"
	elog "select the Ambiance theme in 'System Settings > Appearance'"

	if use test; then
		elog "To run autopilot tests, do the following:"
		elog "cd /usr/$(get_libdir)/${EPYTHON}/site-packages/unity/tests"
		elog "and run 'autopilot run unity'"
		elog
	fi
}

pkg_postrm() {
	gnome2_schemas_update
}
