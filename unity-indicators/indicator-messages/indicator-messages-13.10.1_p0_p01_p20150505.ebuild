# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="wily"
inherit autotools eutils flag-o-matic gnome2-utils ubuntu-versionator vala

UURL="mirror://unity/pool/main/i/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Indicator that collects messages that need a response used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-messages"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="!net-im/indicator-messages
	dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate-qt
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
	append-cflags -Wno-error

	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
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
