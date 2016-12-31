# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
AUTOTOOLS_AUTORECONF=true

URELEASE="yakkety"
inherit autotools-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/z/${PN}"
UVER_PREFIX="+git20160811+2fc86bc"

DESCRIPTION="A brokerless kernel"
HOMEPAGE="http://www.zeromq.org/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="LGPL-3"
SLOT="0/4.0.0"
KEYWORDS="~amd64 ~x86"
IUSE="pgm static-libs test"

RDEPEND="dev-libs/libsodium:=
	pgm? ( =net-libs/openpgm-5.2.122 )"
DEPEND="${RDEPEND}
	!!net-libs/cppzmq
	!!net-libs/zeromq
	sys-apps/util-linux
	pgm? ( virtual/pkgconfig )"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	einfo "Removing bundled OpenPGM library"
	rm -fr "${S}"/foreign/openpgm/libpgm* || die
	sed \
		-e '/libzmq_werror=/s:yes:no:g' \
		-e '/LIBUNWIND_LIBS/a AC_CHECK_LIB([dl], [dladdr])' \
			-i configure.ac || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=()
	use pgm && myeconfargs+=( --with-system-pgm ) || myeconfargs+=( --without-pgm )
	autotools-utils_src_configure
}

src_test() {
	autotools-utils_src_test -j1
}

src_install() {
	autotools-utils_src_install
	doheader "${WORKDIR}/debian/zmq.hpp"
	doman ${BUILD_DIR}/doc/*.[1-9]
}
