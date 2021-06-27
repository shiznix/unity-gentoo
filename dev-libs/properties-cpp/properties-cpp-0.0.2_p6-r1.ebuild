# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="hirsute"
inherit cmake-utils ubuntu-versionator

UVER="-${PVR_MICRO}"

DESCRIPTION="Simple convenience library for handling properties and signals in C++11"
HOMEPAGE="https://launchpad.net/properties-cpp"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}${UVER}.debian.tar.xz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="mirror"

DEPEND="dev-libs/boost
	doc? ( app-doc/doxygen )
        test? ( >=dev-cpp/gtest-1.8.1 )"

S="${WORKDIR}/${PN}-${PV}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	ubuntu-versionator_src_prepare
	use !doc && truncate -s0 doc/CMakeLists.txt
	use !test && truncate -s0 tests/CMakeLists.txt
	cmake-utils_src_prepare
}
