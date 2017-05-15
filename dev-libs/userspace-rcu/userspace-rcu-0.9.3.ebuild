# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

URELEASE="zesty"
inherit autotools-multilib ubuntu-versionator
UVER="-1"

DESCRIPTION="userspace RCU (read-copy-update) library"
HOMEPAGE="http://lttng.org/urcu"
SRC_URI="http://lttng.org/files/urcu/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/2" # subslot = soname version
#KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

MULTILIB_WRAPPED_HEADERS=(/usr/include/urcu/config.h)

src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
	)
	autotools-multilib_src_configure
}
