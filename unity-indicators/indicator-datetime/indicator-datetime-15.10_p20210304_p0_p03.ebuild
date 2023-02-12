# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

URELEASE="kinetic"
inherit cmake gnome2-utils ubuntu-versionator

UVER_PREFIX="+21.04.${PVR_MICRO}"

DESCRIPTION="Date and Time Indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-datetime"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="+eds test"
RESTRICT="mirror"

COMMON_DEPEND="
	dev-libs/libdbusmenu:=
	dev-libs/libtimezonemap:=
	net-libs/libaccounts-glib:=
	media-libs/gstreamer:1.0
	sys-apps/util-linux
	unity-indicators/ido:=
	unity-indicators/indicator-messages
	>=x11-libs/libnotify-0.7.6

	eds? ( >=gnome-extra/evolution-data-server-3.34:= )
	test? ( >=dev-cpp/gtest-1.8.1 )"

RDEPEND="${COMMON_DEPEND}
	unity-base/unity-language-pack"
DEPEND="${COMMON_DEPEND}
	dev-libs/properties-cpp"
# PDEPEND to avoid circular dependency
PDEPEND="unity-base/unity-control-center"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	ubuntu-versionator_src_prepare
	eapply "${FILESDIR}/${PN}-optional-eds_19.10.patch"

	# Fix schema errors and sandbox violations #
	sed -e 's:SEND_ERROR:WARNING:g' \
		-e '/Compiling GSettings schemas/,+1 d' \
			-i cmake/UseGSettings.cmake

	# Disable all language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	sed -i \
		-e "/add_subdirectory(po)/d" \
		CMakeLists.txt

	# Disable tests #
	use test || sed -i \
		-e "/enable_testing()/d" \
		-e "/add_subdirectory(tests)/d" \
		CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_FULL_LOCALEDIR=/usr/share/locale
		-DWITH_EDS="$(usex eds)"
	)
	cmake_src_configure
}

pkg_preinst() {
        gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
