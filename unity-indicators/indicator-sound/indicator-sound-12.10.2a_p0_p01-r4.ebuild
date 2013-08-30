# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VALA_MIN_API_VERSION="0.20"
VALA_USE_DEPEND="vapigen"

inherit cmake-utils ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/i/${PN}"
URELEASE="saucy"
UVER_PREFIX="+13.10.20130829"

DESCRIPTION="System sound indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-sound"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	unity-base/bamf:=
	unity-indicators/ido:="
DEPEND="${RDEPEND}
	dev-libs/libappindicator
	dev-libs/libgee:0
	dev-libs/libindicate-qt
	media-sound/pulseaudio
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	vala_src_prepare
}

src_configure() {
	local mycmakeargs="${mycmakeargs}
		-DVALA_COMPILER=$(type -P valac-0.20)
		-DVAPI_GEN=$(type -P vapigen-0.20)"
	cmake-utils_src_configure
}
