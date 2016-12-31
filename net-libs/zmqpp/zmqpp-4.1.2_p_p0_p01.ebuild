# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit ubuntu-versionator

UURL="mirror://ubuntu/pool/main/z/${PN}"

DESCRIPTION="0mq 'highlevel' C++ bindings"
HOMEPAGE="https://github.com/benjamg/zmqpp"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}${UVER_SUFFIX}.debian.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/zeromq3"
RESTRICT="mirror"

src_prepare() {
	ubuntu-versionator_src_prepare
	sed -e 's:/usr/local:/usr:g' \
		-i Makefile
}

src_configure() { :; }
src_install() {
	dodir /usr/lib
	dodir /usr/include/zmqpp
	emake DESTDIR="${ED}" install
}
