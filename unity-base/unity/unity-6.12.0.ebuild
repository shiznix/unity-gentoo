EAPI=4
PYTHON_DEPEND="2:2.7"

inherit base gnome2 cmake-utils eutils python toolchain-funcs

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu0.2"
URELEASE="quantal-updates"
MY_P="${P/-/_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="The Ubuntu Unity Desktop"
HOMEPAGE="http://unity.ubuntu.com/"

SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!unity-base/unity2d
	dev-libs/boost
	dev-libs/dbus-glib
	>=dev-libs/libappindicator-99.12.10.0
	dev-libs/libindicate[gtk]
	dev-libs/libindicate-qt
	dev-libs/libqtbamf
	dev-libs/libqtdee
	dev-libs/libqtgconf
	dev-libs/libunity
	dev-libs/libunity-misc
	dev-python/gconf-python
	>=gnome-base/gconf-99.3.2.5
	gnome-base/gnome-desktop:3
	>=gnome-base/gnome-menus-99.3.6.0:3
	>=gnome-base/gnome-control-center-99.3.6.3
	>=gnome-base/gnome-settings-daemon-99.3.6.3
	>=gnome-base/gnome-session-99.3.6.0
	>=gnome-base/gsettings-desktop-schemas-99.3.6.0
	gnome-base/gnome-shell
	gnome-base/libgdu
	>=gnome-extra/polkit-gnome-99.0.105
	media-libs/clutter-gtk:1.0
	sys-apps/dbus
	>=sys-devel/gcc-4.6
	unity-base/bamf
	>=unity-base/compiz-0.9.8
	unity-base/dconf-qt
	>=unity-base/nux-3.0.0
	unity-base/overlay-scrollbar
	=x11-base/xorg-server-1.13.0-r9999[dmx]
	=x11-libs/libXfixes-5.0-r9999
	x11-misc/appmenu-gtk
	x11-misc/appmenu-qt
	x11-themes/unity-asset-pool"

pkg_pretend() {
	if [[ ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ) ]]; then
		die "${P} requires an active >=gcc:4.6, please consult the output of 'gcc-config -l'"
	fi
}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${WORKDIR}/${MY_P}-${UVER}.diff"	# This needs to be applied for the debian/ directory to be present #
#	for patch in $(cat "${S}/debian/patches/series" | grep -v '#'); do
#		PATCHES+=( "${S}/debian/patches/${patch}" )
#	done
	PATCHES+=( "${FILESDIR}/stdcerr-fix.patch"
			"${FILESDIR}/gtestdir_fix.patch" )
	base_src_prepare

	python_convert_shebangs -r 2 .

	sed -e "s:/desktop:/org/unity/desktop:g" \
		-i "com.canonical.Unity.gschema.xml" || die

	sed -e "s:Ubuntu Desktop:Unity Gentoo Desktop:g" \
		-i "panel/PanelMenuView.cpp" || die

	# Remove autopilot test suite files #
	sed -e '/python setup.py install/d' \
		-i tests/CMakeLists.txt || die
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
