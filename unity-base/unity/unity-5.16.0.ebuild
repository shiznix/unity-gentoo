EAPI=4

inherit base gnome2 cmake-utils eutils python toolchain-funcs

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu1"
URELEASE="precise-updates"
GNOME2_LA_PUNT="1"
MY_P="${P/-/_}"

DESCRIPTION="The Ubuntu Unity Desktop"
HOMEPAGE="http://unity.ubuntu.com/"

SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="( <unity-base/compiz-0.9.8 unity-base/ccsm unity-base/compizconfig-python x11-libs/libcompizconfig x11-plugins/compiz-plugins-main )
	dev-libs/boost:1.49
	dev-libs/dbus-glib
	dev-libs/libappindicator
	dev-libs/libindicate-qt
	dev-libs/libqtbamf
	dev-libs/libqtdee
	dev-libs/libqtgconf
	dev-libs/libunity
	dev-libs/libunity-misc
	dev-python/gconf-python
	>=gnome-base/gconf-99.3.2.5
	gnome-base/gnome-desktop:3
	>=gnome-base/gnome-menus-99.3.4.0
	>=gnome-base/gnome-control-center-99.3.4.2
	>=gnome-base/gnome-settings-daemon-99.3.4.2
	>=gnome-base/gnome-session-99.3.2.1
	>=gnome-base/gsettings-desktop-schemas-99.3.4.1
	gnome-base/gnome-shell
	gnome-base/libgdu
	>=gnome-extra/polkit-gnome-99.0.105
	media-libs/clutter-gtk:1.0
	sys-apps/dbus
	sys-devel/gcc:4.6
	unity-base/compiz
	unity-base/dconf-qt
	<unity-base/nux-3.0
	=x11-base/xorg-server-1.12.3-r9999
	=x11-libs/libXfixes-5.0-r9999
	x11-misc/appmenu-gtk
	x11-misc/appmenu-qt
	x11-themes/unity-asset-pool"

PATCHES=( "${WORKDIR}/${MY_P}-${UVER}.diff" 
		"${FILESDIR}/stdcerr-fix.patch"
		"${FILESDIR}/gtestdir_fix.patch"
		"${FILESDIR}/dbus-1.6.patch" )

pkg_pretend() {
	if [[ ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ) ]]; then
		die "${P} requires an active >=gcc:4.6, please consult the output of 'gcc-config -l'"
	fi
}

src_prepare() {
	base_src_prepare

	sed -e "s:/desktop:/org/unity/desktop:g" \
		-i "com.canonical.Unity.gschema.xml" || die

	sed -e "s:Ubuntu Desktop:Unity Gentoo Desktop:g" \
		-i "plugins/unityshell/src/PanelMenuView.cpp" || die
}

src_configure() {
	local mycmakeargs="${mycmakeargs}
		-DCOMPIZ_PACKAGING_ENABLED=TRUE
		-DCOMPIZ_PLUGIN_INSTALL_TYPE=package
		-DCOMPIZ_INSTALL_GCONF_SCHEMA_DIR=/etc/gconf/schemas
		-DCOMPIZ_INCLUDEDIR=/usr/include/compiz
		-DCMAKE_INSTALL_PREFIX=/usr"
	cmake-utils_src_configure
}

src_install() {
	pushd ${CMAKE_BUILD_DIR}
	addpredict /root/.gconf		 	# FIXME
	addpredict /usr/share/glib-2.0/schemas/	# FIXME
	addpredict $(python_get_sitedir)	# FIXME
	emake DESTDIR="${D}" install
	popd ${CMAKE_BUILD_DIR}
}

pkg_postinst() {
	einfo
	einfo "It is recommended to enable the 'ayatana' USE flag"
	einfo "for portage packages so they can use the Unity"
	einfo "libindicate or libappindicator notification plugins"
	einfo
	einfo "If you would like to use Unity's icons and themes"
	einfo "'emerge light-themes ubuntu-mono gnome-tweak-tool'"
	einfo "then run 'gnome-tweak-tool' as your desktop user and choose"
	einfo "Ambiance GTK+ theme and Ubunto-mono-dark icon theme"
	einfo

	gnome2_pkg_postinst
}
