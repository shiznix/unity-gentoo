# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="jammy"
inherit cmake ubuntu-versionator

UVER_PREFIX="+14.04.${PVR_MICRO}"

DESCRIPTION="Qt binding and QML plugin for Dee for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=dev-libs/dee-1.2.7
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

PATCHES=( "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}${UVER_SUFFIX}.diff" )

src_prepare() {
	ubuntu-versionator_src_prepare
	# Correct library installation path #
	sed \
		-e 's:LIBRARY DESTINATION lib/\${CMAKE_LIBRARY_ARCHITECTURE}:LIBRARY DESTINATION lib\${CMAKE_LIBRARY_ARCHITECTURE}:' \
		-e '/pkgconfig/{s/\/\${CMAKE_LIBRARY_ARCHITECTURE}/\${CMAKE_LIBRARY_ARCHITECTURE}\${LIB_SUFFIX}/}' \
		-i CMakeLists.txt
	sed \
		-e 's:lib/@CMAKE_LIBRARY_ARCHITECTURE@:lib@CMAKE_LIBRARY_ARCHITECTURE@@LIB_SUFFIX@:' \
		-i libdee-qt.pc.in
	cmake_src_prepare
}

src_configure() {
	mycmakeargs+=(-DWITHQT5=1
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_BUILD_TYPE=Release)
	cmake_src_configure
}
