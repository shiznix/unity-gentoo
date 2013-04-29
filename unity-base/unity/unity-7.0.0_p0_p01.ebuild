# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.7"

inherit base gnome2 cmake-utils eutils python toolchain-funcs ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.04.18~13.04"

DESCRIPTION="The Ubuntu Unity Desktop"
HOMEPAGE="https://launchpad.net/unity"

SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+branding"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

RDEPEND="dev-libs/dee:=
	dev-libs/libdbusmenu:=
	dev-libs/libunity-misc:=
	>=unity-base/bamf-0.4.0:=
	>=unity-base/compiz-0.9.9:=
	>=unity-base/nux-4.0.0:=
	unity-base/unity-language-pack
	x11-themes/humanity-icon-theme
	x11-themes/unity-asset-pool"
DEPEND="dev-libs/boost
	dev-libs/dee
	dev-libs/dbus-glib
	dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate[gtk,introspection]
	dev-libs/libindicate-qt
	>=dev-libs/libindicator-12.10.2
	dev-libs/libunity
	dev-libs/libunity-misc
	dev-python/gconf-python
	>=gnome-base/gconf-3.2.5
	gnome-base/gnome-desktop:3
	>=gnome-base/gnome-menus-3.6.0:3
	>=gnome-base/gnome-control-center-3.6.3
	>=gnome-base/gnome-settings-daemon-3.6.3
	>=gnome-base/gnome-session-3.6.0
	>=gnome-base/gsettings-desktop-schemas-3.6.0
	gnome-base/gnome-shell
	gnome-base/libgdu
	>=gnome-extra/polkit-gnome-0.105
	media-libs/clutter-gtk:1.0
	sys-apps/dbus
	>=sys-devel/gcc-4.7.3
	>=unity-base/bamf-0.4.0
	>=unity-base/compiz-0.9.9
	unity-base/dconf-qt
	>=unity-base/nux-4.0.0
	unity-base/overlay-scrollbar
	x11-base/xorg-server[dmx]
	x11-libs/libXfixes
	x11-misc/appmenu-gtk
	x11-misc/appmenu-qt"

pkg_pretend() {
	if [[ $(gcc-major-version) -lt 4 ]] || \
		( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 ]] ) || \
			( [[ $(gcc-version) == "4.7" && $(gcc-micro-version) -lt 3 ]] ); then
				die "${P} requires an active >=gcc-4.7.3, please consult the output of 'gcc-config -l'"
	fi
}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"	# This needs to be applied for the debian/ directory to be present #
	PATCHES+=( "${FILESDIR}/re-whitelist-raring.diff"
			"${FILESDIR}/systray-enabled-by-default.diff"
			"${FILESDIR}/remove-gtest-dep.diff" )
	base_src_prepare

	python_convert_shebangs -r 2 .

	sed -e "s:/desktop:/org/unity/desktop:g" \
		-i "com.canonical.Unity.gschema.xml" || die

	sed -e "s:Ubuntu Desktop:Unity Gentoo Desktop:g" \
		-i "panel/PanelMenuView.cpp" || die

	# Remove autopilot test suite files #
	sed -e '/python setup.py install/d' \
		-i tests/CMakeLists.txt || die

	# Unset CMAKE_BUILD_TYPE env variable so that cmake-utils.eclass doesn't try to 'append-cppflags -DNDEBUG' #
	#       resulting in build failure with 'fatal error: unitycore_pch.hh: No such file or directory' #
	export CMAKE_BUILD_TYPE=none

	# Disable '-Werror'
	sed -i 's/[ ]*-Werror[ ]*//g' CMakeLists.txt services/CMakeLists.txt
}

src_configure() {
	local mycmakeargs="${mycmakeargs}
		-DCOMPIZ_PACKAGING_ENABLED=TRUE
		-DCOMPIZ_PLUGIN_INSTALL_TYPE=package
		-DCOMPIZ_INSTALL_GCONF_SCHEMA_DIR=/etc/gconf/schemas
		-DCMAKE_INSTALL_PREFIX=/usr"
	cmake-utils_src_configure
}

src_install() {
	pushd ${CMAKE_BUILD_DIR}
		addpredict /root/.gconf		 	# FIXME
		addpredict /usr/share/glib-2.0/schemas/	# FIXME
		emake DESTDIR="${D}" install
	popd ${CMAKE_BUILD_DIR}

	# Gentoo dash launcher icon #
	if use branding; then
		insinto /usr/share/unity/6
		doins "${FILESDIR}/launcher_bfb.png"
	fi

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"

	# Make searchingthedashlegalnotice.html available to gnome-control-center's Details > Legal Notice #
	dosym /usr/share/unity/6/searchingthedashlegalnotice.html \
		/usr/share/gnome-control-center/searchingthedashlegalnotice.html
}

pkg_postinst() {
	einfo
	einfo "It is recommended to enable the 'ayatana' USE flag"
	einfo "for portage packages so they can use the Unity"
	einfo "libindicate or libappindicator notification plugins"
	einfo
	einfo "If you would like to use Unity's icons and themes"
	einfo "select the Ambiance theme in 'System Settings > Appearance'"
	einfo

	gnome2_pkg_postinst
}
