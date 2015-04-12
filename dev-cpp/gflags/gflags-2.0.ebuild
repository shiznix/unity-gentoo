# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="utopic"
inherit ubuntu-versionator

UVER="2.1"

DESCRIPTION="Google's C++ argument parsing library"
HOMEPAGE="http://code.google.com/p/gflags/"
SRC_URI="http://gflags.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die

	rm -rf "${ED}"/usr/share/doc/*
	dodoc AUTHORS ChangeLog NEWS README
	dohtml doc/*
}
