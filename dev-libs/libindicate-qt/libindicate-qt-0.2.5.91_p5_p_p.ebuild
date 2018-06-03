# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="bionic"
inherit virtualx cmake-utils ubuntu-versionator

UVER="-${PVR_MICRO}"

DESCRIPTION="Qt wrapper for libindicate library"
HOMEPAGE="https://launchpad.net/libindicate-qt/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}${UVER}.debian.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

RDEPEND=">=dev-libs/libindicate-12.10.0
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-qt/qttest:4 )"

# bug #440042
RESTRICT="mirror test"

src_prepare() {
	ubuntu-versionator_src_prepare
	cmake-utils_src_prepare
	use examples || \
		sed -e '/examples/d' -i CMakeLists.txt
	use test || \
		sed -e '/tests/d' -i CMakeLists.txt
}

src_test() {
	local ctestargs
	[[ -n ${TEST_VERBOSE} ]] && ctestargs="--extra-verbose --output-on-failure"
	cd "${CMAKE_BUILD_DIR}"/tests
	VIRTUALX_COMMAND="ctest ${ctestargs}" virtualmake || die
}
