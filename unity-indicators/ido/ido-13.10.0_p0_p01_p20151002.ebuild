# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

URELEASE="wily"
inherit autotools eutils flag-o-matic gnome2 ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/i/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Widgets and other objects used for indicators by the Unity desktop"
HOMEPAGE="https://launchpad.net/ido"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	 ${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0/0.0.0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=dev-libs/glib-2.37
	x11-libs/gtk+:3
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff" || die

	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"

	append-cflags -Wno-error
	eautoreconf
}
