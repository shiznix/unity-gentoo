# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GTESTVER="1.8.1"

URELEASE="jammy"
inherit cmake ubuntu-versionator

UVER_PREFIX="+15.10.${PVR_MICRO}"

DESCRIPTION="Select objects in an object tree using XPath queries"
HOMEPAGE="https://launchpad.net/xpathselect"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	test? ( https://github.com/google/googletest/archive/release-${GTESTVER}.tar.gz -> gtest-${GTESTVER}.tar.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="test? ( dev-cpp/gtest )
	dev-libs/boost"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	! use test && \
		sed -e '/add_subdirectory(test)/d' \
			-i CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	use test && \
		mycmakeargs+=(-DGTEST_ROOT_DIR="${WORKDIR}/gtest-${GTESTVER}"
				-DGTEST_SRC_DIR="${WORKDIR}/gtest-${GTESTVER}/src/")
	cmake_src_configure
}
