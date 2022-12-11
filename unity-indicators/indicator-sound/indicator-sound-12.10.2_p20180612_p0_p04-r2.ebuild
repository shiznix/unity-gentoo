# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="jammy"
inherit cmake gnome2-utils ubuntu-versionator vala

UVER_PREFIX="+18.10.${PVR_MICRO}"

DESCRIPTION="System sound indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-sound"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

RDEPEND="sys-auth/polkit-pkla-compat
	unity-base/gsettings-ubuntu-touch-schemas"
DEPEND="${RDEPEND}
	sys-apps/accountsservice
	dev-lang/vala:0.52
	dev-libs/libappindicator
	dev-libs/libgee:0.8
	dev-libs/libdbusmenu:=
	dev-util/dbus-test-runner
	media-sound/pulseaudio
	unity-base/bamf:=
	unity-base/unity-api
	unity-indicators/ido:=
	>=x11-libs/libnotify-0.7.6
	test? ( >=dev-cpp/gtest-1.8.1
		dev-libs/libqtdbusmock
		dev-libs/libqtdbustest )"

S="${WORKDIR}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	eapply "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"
	ubuntu-versionator_src_prepare

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

	vala_src_prepare
	export VALAC=$(type -P valac-0.52)
	export VALA_API_GEN="$VAPIGEN"
	cmake_src_prepare
}

src_configure() {
	mycmakeargs+=(-DCMAKE_INSTALL_LOCALSTATEDIR=/var
		-DVALA_COMPILER=$VALAC
		-DVAPI_GEN=$VAPIGEN
		-DCMAKE_INSTALL_FULL_DATADIR=/usr/share)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	find "${ED}" -name "*.pkla" -exec chown root:polkitd {} \;
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
}
