EAPI=4

inherit base gnome2 cmake-utils eutils python toolchain-funcs

MY_PN="unity-2d"
UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${MY_PN}"
UVER="0ubuntu1.1"
URELEASE="precise"
GNOME2_LA_PUNT="1"

DESCRIPTION="The Ubuntu Unity Desktop for non-accelerated graphics cards"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_PN}_${PV}.orig.tar.gz
	${UURL}/${MY_PN}_${PV}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libqtgconf
	unity-base/unity
	x11-libs/libwnck:3
	>=x11-libs/qt-test-99.4.8.2:4
	>=x11-wm/metacity-99.2.34.1"

S="${WORKDIR}/unity-2d-${PV}"

PATCHES=( "${WORKDIR}/${MY_PN}_${PV}-${UVER}.diff" 
		"${FILESDIR}/libqt-QMouseEvent_fix.patch" )

src_prepare() {
	base_src_prepare

	sed -e "s:Ubuntu Desktop:Unity Gentoo Desktop:g" \
                -i "panel/applets/appname/appnameapplet.cpp" || die
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_LIBDIR=lib"
	cmake-utils_src_configure
}

src_install() {
	pushd ${CMAKE_BUILD_DIR}
		addpredict /usr/share/glib-2.0/schemas/
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
	einfo "'emerge light-themes ubuntu-mono gnome-tweak-tool'"
	einfo "then run 'gnome-tweak-tool' as your desktop user and choose"
	einfo "Ambiance GTK+ theme and Ubunto-mono-dark icon theme"
	einfo

	gnome2_pkg_postinst
}
