# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
CMAKE_BUILD_TYPE=none

URELEASE="wily"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/p/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Cache of key-value pairs with persistent storage for C++11"
HOMEPAGE="https://launchpad.net/persistent-cache-cpp"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

DEPEND="dev-libs/boost:=
	dev-libs/leveldb
	dev-util/cmake-extras
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	# Make the library shared instead of static #
	#	This has wider implications when fixing GCC breaking C++11 ABI compatibility #
	#		as rebuild tools such as revdep-rebuild will only work with shared objects #
	#	eg. undefined reference to `core::PersistentCacheStats::cache_path[abi:cxx11]()const
	sed -e 's:STATIC:SHARED:g' \
		-i src/core/CMakeLists.txt

	use doc || \
		sed -e '/doc\/html/d' \
			-e '/share\/doc/d' \
				-i CMakeLists.txt
	cmake-utils_src_prepare
}
