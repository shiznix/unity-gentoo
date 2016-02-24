# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="wily"
inherit cmake-utils gnome2-utils ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/i/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Date and Time Indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-datetime"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="unity-base/unity-language-pack"
DEPEND="${RDEPEND}
	dev-libs/libappindicator:=
	dev-libs/libdbusmenu:=
	dev-libs/libindicate-qt
	dev-libs/libtimezonemap:=
	dev-libs/properties-cpp
	gnome-extra/evolution-data-server:=
	net-misc/url-dispatcher
	unity-indicators/ido:=
	unity-base/unity-control-center
	>=x11-libs/libnotify-0.7.6"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff" || die

	# Fix schema errors and sandbox violations #
	epatch -p1 "${FILESDIR}/sandbox_violations_fix.diff"

	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
}

src_configure() {
	mycmakeargs+=(-DVALA_COMPILER=$VALAC
		-DVAPI_GEN=$VAPIGEN)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
	gnome2_icon_savelist
}

src_install() {
	cmake-utils_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
