
# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_SINGLE_IMPL=1

URELEASE="kinetic"
inherit cmake distutils-r1 eutils gnome2-utils pam systemd toolchain-funcs ubuntu-versionator xdummy

UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"
GLEWMX="glew-1.13.0"

DESCRIPTION="The Ubuntu Unity Desktop"
HOMEPAGE="https://launchpad.net/unity"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.tar.xz
	mirror://sourceforge/glew/${GLEWMX}.tgz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="+branding debug doc +hud +nemo pch +systray test"
RESTRICT="mirror"

S="${WORKDIR}/${PN}"
CMAKE_MAKEFILE_GENERATOR="emake"	# cmake.eclass forces ninja but suffers from lexing errors

RDEPEND="app-i18n/ibus[gtk3]
	>=sys-apps/systemd-232
	sys-auth/polkit-pkla-compat
	unity-base/gsettings-ubuntu-touch-schemas
	unity-base/session-shortcuts
	unity-base/unity-language-pack
	x11-themes/humanity-icon-theme
	x11-themes/gtk-engines-murrine
	x11-themes/unity-asset-pool
	hud? ( unity-base/hud )
	nemo? ( gnome-extra/nemo )"
DEPEND="${RDEPEND}
	!sys-apps/upstart
	!unity-base/dconf-qt
	dev-libs/appstream-glib
	>=dev-libs/boost-1.71:=
	dev-libs/dee:=
	dev-libs/dbus-glib
	dev-libs/icu:=
	dev-libs/libappindicator
	dev-libs/libdbusmenu:=
	dev-libs/libffi
	dev-libs/libindicate[gtk,introspection]
	dev-libs/libindicator
	dev-libs/libsigc++:2
	dev-libs/libunity
	dev-libs/libunity-misc:=
	dev-libs/xpathselect
	gnome-base/gconf
	gnome-base/gnome-desktop:3=
	gnome-base/gnome-menus:3
	gnome-base/gnome-session[systemd]
	gnome-base/gsettings-desktop-schemas
	gnome-extra/polkit-gnome:0
	media-libs/glew:=
	media-libs/mesa
	sys-apps/dbus[systemd,X]
	sys-auth/pambase
	unity-base/bamf:=
	unity-base/compiz:=
	unity-base/nux:=[debug?]
	unity-base/overlay-scrollbar
	unity-base/unity-control-center
	unity-base/unity-settings-daemon
	x11-base/xorg-server
	>=x11-libs/cairo-1.13.1
	x11-libs/libXfixes
	x11-libs/startup-notification
	unity-base/unity-gtk-module
	doc? ( app-doc/doxygen )
	test? ( >=dev-cpp/gtest-1.8.1
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
	ubuntu-versionator_src_prepare

	# Fix build failure with >=media-libs/mesa-18.2.5 due to header conflicts with media-libs/glew (see https://github.com/shiznix/unity-gentoo/issues/205) #
	pushd "${WORKDIR}/${GLEWMX}"
		eapply -p1 "${FILESDIR}/glew-1.13.0-mesa-compat.patch"
	popd

	# Taken from http://ppa.launchpad.net/timekiller/unity-systrayfix/ubuntu/pool/main/u/unity/ #
	if use systray; then
		eapply -p1 "${FILESDIR}/systray-fix_disco.diff"
	fi

	# Setup Unity side launcher default applications #
	sed \
		-e "/firefox/r ${FILESDIR}/www-clients" \
		-e '/ubiquity/d' \
		-e '/org.gnome.Software/d' \
			-i data/com.canonical.Unity.gschema.xml || die

	sed -e "s:Ubuntu Desktop:Unity Gentoo Desktop:g" \
		-i panel/PanelMenuView.cpp || die

	# Remove testsuite cmake installation #
	sed -e '/setup.py install/d' \
			-i tests/CMakeLists.txt || die "Sed failed for tests/CMakeLists.txt"

	# Unset CMAKE_BUILD_TYPE env variable so that cmake.eclass doesn't try to 'append-cppflags -DNDEBUG' #
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

	# Include directly iostream needed for std::ostream #
	sed -s 's/.*GLibWrapper.h.*/#include <iostream>\n&/' \
		-i UnityCore/GLibWrapper.cpp || die "Sed failed for UnityCore/GLibWrapper.cpp"

	# New stable dev-libs/boost-1.71 compatibility changes #
	sed -s 's:boost/utility.hpp:boost/next_prior.hpp:g' \
		-i launcher/FavoriteStorePrivate.cpp || die

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
	sed -e 's:After=\(unity-settings-daemon.service\):After=graphical-session-pre.target gnome-session.service bamfdaemon.service \1:' \
		-i data/unity7.service.in || \
			die "Sed failed for data/unity7.service.in"

	# Apps launched from u-c-c need GTK_MODULES environment variable with unity-gtk-module value #
	#	to use unity global/titlebar menu. Disable unity-gtk-module.service as it sets only #
	#	dbus/systemd environment variable. We are providing xinit.d script to set GTK_MODULES #
	#	environment variable to load unity-gtk-module (see unity-base/unity-gtk-module package) #
	sed -e 's:unity-gtk-module.service ::' \
			-i data/unity7.service.in

	# Don't use drop-down menu icon from Adwaita theme as it's too dark since v3.30 #
	sed -i "s/go-down-symbolic/drop-down-symbolic/" decorations/DecorationsMenuDropdown.cpp

	# Fix building with GCC 10 #
	sed -i '/#include "GLibWrapper.h"/a #include <iostream>/' UnityCore/GLibWrapper.cpp
	sed -i '/#include <functional>/a #include <string>' UnityCore/GLibSource.h
	sed -i '/#include <core\/screen.h>/a #include <iostream>' unity-shared/CompizUtils.cpp
	sed -i '/#include "GLibWrapper.h"/a #include <vector>' UnityCore/ScopeData.h
	sed -i '/#include <NuxCore\/Property.h>/a #include <vector>' unity-shared/ThemeSettings.h

	cmake_src_prepare
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

	# Disable all language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	mycmakeargs+=(-DI18N_SUPPORT=OFF)

	mycmakeargs+=(-DCOMPIZ_BUILD_WITH_RPATH=FALSE
		-DCOMPIZ_PACKAGING_ENABLED=TRUE
		-DCOMPIZ_PLUGIN_INSTALL_TYPE=package
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
		-DCMAKE_INSTALL_LOCALSTATEDIR=/var)
	CXXFLAGS+=" -I${WORKDIR}/${GLEWMX}/include"
	cmake_src_configure || die
}

src_compile() {
	if use test; then
		pushd tests/autopilot
			distutils-r1_src_compile
		popd
	fi

	cmake_src_compile || die
}

src_test() {
	pushd ${BUILD_DIR}
		local XDUMMY_COMMAND="make check-headless"
		xdummymake
	popd
}

src_install() {
	pushd ${BUILD_DIR}
		addpredict /usr/share/glib-2.0/schemas/	# FIXME
		emake DESTDIR="${ED}" install
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

	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/70im-config"			# Configure input method (xim/ibus)
	doexe "${FILESDIR}/99unity-session_systemd"	# Unity session environment setup and 'startx' launcher

	# Some newer multilib profiles have different /usr/lib(32,64)/ paths so insert the correct one
	local fixlib=$(get_libdir)
	sed -e "s:/usr/lib/:/usr/${fixlib}/:g" \
		-i "${ED}/etc/X11/xinit/xinitrc.d/70im-config" || die
	sed -e "/nux\/unity_support_test/{s/lib/${fixlib}/}" \
		-i "${ED}/usr/${fixlib}/unity/compiz-profile-selector" || die

	# Clean up pam file installation as used in lockscreen (LP# 1305440) #
	rm -rf "${ED}"/etc/pam.d || die
	pamd_mimic system-local-login ${PN} auth account session

	# Set base desktop user privileges #
	insinto /var/lib/polkit-1/localauthority/10-vendor.d
	doins "${FILESDIR}/com.ubuntu.desktop.pkla"
	fowners root:polkitd /var/lib/polkit-1/localauthority/10-vendor.d/com.ubuntu.desktop.pkla

	# Make 'unity-session.target' systemd user unit auto-start 'unity7.service' #
	dosym $(systemd_get_userunitdir)/unity7.service $(systemd_get_userunitdir)/unity-session.target.requires/unity7.service
	# Disable service, see unity-gtk-module.service in src_prepare phase
	#dosym $(systemd_get_userunitdir)/unity-gtk-module.service $(systemd_get_userunitdir)/unity-session.target.wants/unity-gtk-module.service
	dosym $(systemd_get_userunitdir)/unity-settings-daemon.service $(systemd_get_userunitdir)/unity-session.target.wants/unity-settings-daemon.service
	dosym $(systemd_get_userunitdir)/window-stack-bridge.service $(systemd_get_userunitdir)/unity-session.target.wants/window-stack-bridge.service

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
