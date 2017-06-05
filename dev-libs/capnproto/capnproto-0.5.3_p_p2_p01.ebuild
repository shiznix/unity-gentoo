# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

URELEASE="yakkety"
inherit eutils autotools-multilib ubuntu-versionator

UURL="mirror://ubuntu/pool/main/c/${PN}"

DESCRIPTION="RPC/Serialization system with capabilities support"
HOMEPAGE="http://capnproto.org"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}/${PN}-c++-${PV}"

src_prepare() {
	ubuntu-versionator_src_prepare
	autotools-multilib_src_prepare
	sed -e '/ldconfig/d' \
		-i Makefile.am
}

src_configure() {
	autotools-multilib_src_configure

	# Build will try to create files in source's 'cmake/' directory #
	# This will fail when directory doesn't exist in multilib build dirs, so manually create it #
	build_dir_setup() {
		pushd "${BUILD_DIR}"
			mkdir cmake
		popd
	}
	multilib_foreach_abi build_dir_setup
}
