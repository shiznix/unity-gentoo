# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

XORG_MULTILIB=yes
inherit base eutils xorg-2 ubuntu-versionator

MY_PN="libxfixes"
MY_P="${MY_PN}_${PV}"
MY_PV="${PV}"

UURL="mirror://ubuntu/pool/main/libx/${MY_PN}"
URELEASE="saucy"

DESCRIPTION="Ubuntu patched version of X.Org Xfixes library needed for Unity desktop"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="<x11-libs/libX11-1.6.0[${MULTILIB_USEDEP}]
	>=x11-proto/fixesproto-5[${MULTILIB_USEDEP}]
	x11-proto/xproto[${MULTILIB_USEDEP}]
	x11-proto/xextproto[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${WORKDIR}/${MY_P}-${UVER}${UVER_SUFFIX}.diff"
	for patch in $(cat "${WORKDIR}/${PN}-${MY_PV}/${MY_PN}-${MY_PV}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/${PN}-${MY_PV}/${MY_PN}-${MY_PV}/debian/patches/${patch}" )
	done
	base_src_prepare
}
