# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="wily"
inherit autotools-multilib ubuntu-versionator

UVER_SUFFIX="~gcc5.1ubuntu1"

DESCRIPTION="Google's C++ argument parsing library"
HOMEPAGE="http://code.google.com/p/gflags/"
SRC_URI="http://gflags.googlecode.com/files/${PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
	)
	autotools-multilib_src_configure
}

src_install() {
	autotools-multilib_src_install

	rm -rf "${ED}"/usr/share/doc/*
	dodoc AUTHORS ChangeLog NEWS README
	dohtml doc/*
}
