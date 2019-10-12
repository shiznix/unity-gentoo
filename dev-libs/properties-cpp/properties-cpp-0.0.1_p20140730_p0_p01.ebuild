# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="cosmic"
inherit cmake-utils

MY_PV="${PV:0:5}+14.10.${PV:7:8}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Simple convenience library for handling properties and signals in C++11"
HOMEPAGE="https://launchpad.net/properties-cpp"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="mirror"

DEPEND="dev-libs/boost
	doc? ( app-doc/doxygen )
        test? ( dev-cpp/gtest
                dev-cpp/gmock )"

S="${WORKDIR}/${MY_P}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	use !doc && truncate -s0 doc/CMakeLists.txt
	use !test && truncate -s0 tests/CMakeLists.txt
	cmake-utils_src_prepare
}
