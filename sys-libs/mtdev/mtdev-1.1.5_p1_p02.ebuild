# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

URELEASE="wily"
inherit autotools-multilib ubuntu-versionator

DESCRIPTION="Multitouch Protocol Translation Library"
HOMEPAGE="http://bitmath.org/code/mtdev/"
SRC_URI="http://bitmath.org/code/mtdev/${PN}-${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

DEPEND=">=sys-kernel/linux-headers-2.6.31"

src_configure() {
	local myeconfargs=(
		econf $(use_enable static-libs static)
	)
	autotools-multilib_src_configure
}

src_install() {
	autotools-multilib_src_install
	find "${ED}" -name '*.la' -exec rm -f {} +
}
