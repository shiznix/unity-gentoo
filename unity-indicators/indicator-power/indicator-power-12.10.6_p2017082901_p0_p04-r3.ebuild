# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="disco"
inherit cmake-utils gnome2-utils ubuntu-versionator

UVER_PREFIX="+17.10.${PVR_MICRO}"

DESCRIPTION="Indicator showing power state used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-power"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+powerman test"
RESTRICT="mirror"

RDEPEND="powerman? ( gnome-extra/gnome-power-manager )"
DEPEND="${RDEPEND}
	dev-libs/glib:2
	dev-libs/libappindicator
	dev-libs/libdbusmenu
	sys-power/upower
	unity-base/unity-settings-daemon

	test? ( dev-cpp/gmock )"

S="${WORKDIR}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	ubuntu-versionator_src_prepare
	eapply "${FILESDIR}/sandbox_violations_fix.diff"

	# Disable url-dispatcher when not using unity8-desktop-session
	eapply "${FILESDIR}/disable-url-dispatcher.diff"

	# Deactivate gnome-power-statistics launcher
	use powerman \
		|| eapply "${FILESDIR}/disable-powerman.diff"

	# Remove all language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	sed -i \
		-e "/add_subdirectory(po)/d" \
		CMakeLists.txt

	# Remove tests #
	use test || sed -i \
		-e "/enable_testing()/d" \
		-e "/add_subdirectory(tests)/d" \
		CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_FULL_LOCALEDIR=/usr/share/locale
	)

	cmake-utils_src_configure
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
