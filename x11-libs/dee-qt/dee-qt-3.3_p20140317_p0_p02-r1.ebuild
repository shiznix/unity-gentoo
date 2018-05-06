# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="artful"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/main/d/${PN}"
#UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"
UVER_PREFIX="+14.04.${PVR_MICRO}"
UVER_SUFFIX="~gcc5.1"

DESCRIPTION="Qt binding and QML plugin for Dee for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}${UVER_SUFFIX}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="qt4 qt5"
REQUIRED_USE="|| ( qt4 qt5 )"
RESTRICT="mirror"

RDEPEND=">=dev-libs/dee-1.2.7
	dev-libs/glib:2
	qt4? ( dev-qt/qtcore:4
		dev-qt/qtdeclarative:4 )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtdeclarative:5 )"
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
	cmake-utils_src_prepare
}

src_configure() {
	# Build QT4 support #
	if use qt4; then
		cd "${WORKDIR}"
		cp -rf "${S}" "${S}-build_qt4"
		mycmakeargs+=(-DWITHQT5=0
			-DCMAKE_INSTALL_PREFIX=/usr
			-DIMPORT_INSTALL_DIR=lib/qt/imports/dee
			-DCMAKE_BUILD_TYPE=Release)
		BUILD_DIR="${S}-build_qt4" cmake-utils_src_configure
	fi

	# Build QT5 support #
	if use qt5; then
		cd "${WORKDIR}"
		cp -rf "${S}" "${S}-build_qt5"
		mycmakeargs+=(-DWITHQT5=1
			-DCMAKE_INSTALL_PREFIX=/usr
			-DIMPORT_INSTALL_DIR=lib/qt/imports/dee
			-DCMAKE_BUILD_TYPE=Release)
		BUILD_DIR="${S}-build_qt5" cmake-utils_src_configure
	fi
}

src_compile() {
	# Build QT4 support #
	if use qt4; then
		BUILD_DIR="${S}-build_qt4" cmake-utils_src_compile
	fi

	# Build QT5 support #
	if use qt5; then
		BUILD_DIR="${S}-build_qt5" cmake-utils_src_compile
	fi
}

src_install() {
	# Build QT4 support #
	if use qt4; then
		BUILD_DIR="${S}-build_qt4" cmake-utils_src_install
	fi

	# Build QT5 support #
	if use qt5; then
		BUILD_DIR="${S}-build_qt5" cmake-utils_src_install
	fi
}
