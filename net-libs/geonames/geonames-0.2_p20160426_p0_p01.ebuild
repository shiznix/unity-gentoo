# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit autotools eutils ubuntu-versionator

UURL="mirror://unity/pool/main/g/${PN}"
UVER_PREFIX="+16.04.${PVR_MICRO}"

DESCRIPTION="Parse and query the geonames database dump"
HOMEPAGE="https://launchpad.net/geonames"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-util/gtk-doc"

S="${WORKDIR}/${PN}"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_install() {
	default
	prune_libtool_files --modules
}
