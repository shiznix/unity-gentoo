EAPI=4

inherit gnome2 cmake-utils eutils python toolchain-funcs

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu4"
URELEASE="precise"
GNOME2_LA_PUNT="1"

DESCRIPTION="The Ubuntu Unity Desktop"
HOMEPAGE="http://unity.ubuntu.com/"

SRC_URI="${UURL}/${PN}_5.12.orig.tar.gz
	${UURL}/${PN}_5.12-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/boost:1.49
	dev-libs/libcompizconfig
	>=dev-libs/libappindicator-0.4.92
	dev-libs/libindicate-qt
	dev-libs/libqtbamf
	dev-libs/libqtdee
	dev-libs/libqtgconf
	dev-libs/libunity
	dev-libs/libunity-misc
	dev-python/gconf-python
	gnome-base/gnome-desktop:3
	>=gnome-base/gnome-control-center-99.3.4.2
	>=gnome-base/gnome-menus-99.3.4.0
	>=gnome-base/gnome-settings-daemon-99.3.4.2
	>=gnome-base/gnome-session-99.3.2.1
	>=gnome-base/gsettings-desktop-schemas-99.3.4.1
	>=gnome-base/nautilus-99.3.4.2
	gnome-base/gnome-shell
	gnome-base/libgdu
	media-libs/clutter-gtk:1.0
	<sys-apps/dbus-1.6.0
	sys-devel/gcc:4.6
	unity-base/ccsm
	unity-base/compiz
	unity-base/compizconfig-python
	unity-base/compiz-plugins-main
	unity-base/dconf-qt
	unity-base/nux
	>=x11-base/xorg-server-1.12.0
	=x11-libs/libXfixes-5.0-r9999
	x11-misc/appmenu-gtk
	x11-misc/appmenu-qt
	x11-themes/unity-asset-pool"

PATCHES=( "${WORKDIR}/${PN}_5.12-${UVER}.diff" )

src_prepare() {
	base_src_prepare
	epatch "${FILESDIR}/${P}_stdcerr-fix.patch"
	epatch "${FILESDIR}/${P}_gtestdir_fix.patch"

	sed -e "s:/desktop:/org/unity/desktop:g" \
		-i "com.canonical.Unity.gschema.xml" || die

	if [[ ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ) ]]; then
		die "${P} requires an active gcc:4.6, please consult the output of 'gcc-config -l'"
	fi

	sed -e "s:Ubuntu Desktop:Unity Gentoo Desktop:g" \
		-i "plugins/unityshell/src/PanelMenuView.cpp" || die
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DCOMPIZ_PACKAGING_ENABLED=TRUE
		-DCOMPIZ_PLUGIN_INSTALL_TYPE=package
		-DCOMPIZ_INSTALL_GCONF_SCHEMA_DIR=/etc/gconf/schemas
		-DCMAKE_INSTALL_PREFIX=/usr"
	cmake-utils_src_configure
}

src_install() {
	pushd ${CMAKE_BUILD_DIR}
	addpredict /root/.gconf
	addpredict /usr/share/glib-2.0/schemas/
	addpredict $(python_get_sitedir)
	DESTDIR="${D}" emake install
	popd ${CMAKE_BUILD_DIR}
}

pkg_postinst() {
	einfo
	einfo "It is recommended to enable the 'ayatana' USE flag"
	einfo "for portage packages so they can use the Unity"
	einfo "libindicate or libappindicator notification plugins"
	einfo
	einfo "If you would like to use Unity's icons and themes"
	einfo "'emerge light-themes humanity-icon-theme gnome-tweak-tool'"
	einfo "then run 'gnome-tweak-tool' as your desktop user and choose"
	einfo "Ambiance and Humanity themes"
	einfo
}
