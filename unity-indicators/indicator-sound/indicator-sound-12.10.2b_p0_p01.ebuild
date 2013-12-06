# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils gnome2-utils ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/i/${PN}"
URELEASE="trusty"
UVER_PREFIX="+14.04.20131029.1"

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
	net-misc/url-dispatcher
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	vala_src_prepare

# Make "Sound Settings" open gnome-control-center sound settings #
	sed -e 's:sound-nua:sound:g' \
		-i src/service.vala
}

src_configure() {
	local mycmakeargs="${mycmakeargs}
		-DVALA_COMPILER=$(type -P valac-0.20)
		-DVAPI_GEN=$(type -P vapigen-0.20)"
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
