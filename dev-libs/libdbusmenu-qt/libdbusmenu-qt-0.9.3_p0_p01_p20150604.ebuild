# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="wily"
inherit cmake-utils virtualx ubuntu-versionator

UURL="mirror://ubuntu/pool/main/libd/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="A library providing Qt implementation of DBusMenu specification"
HOMEPAGE="https://launchpad.net/libdbusmenu-qt/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug doc qt5"
# tests fail due to missing conection to dbus
RESTRICT="mirror test"

RDEPEND="dev-libs/qjson
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qttest:4
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qttest:5 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
DOCS=( NEWS README )

src_configure() {
	mycmakeargs+=( $(cmake-utils_use_build test TESTS)
			$(cmake-utils_use_with doc) )

	# Build QT4 support #
	cd "${WORKDIR}"
	cp -rf "${S}" "${S}-build_qt4"
	mycmakeargs+=(-DUSE_QT4=ON)
	BUILD_DIR="${S}-build_qt4" cmake-utils_src_configure

	# Build QT5 support #
	if use qt5; then
		cd "${WORKDIR}"
		cp -rf "${S}" "${S}-build_qt5"
		mycmakeargs+=(-DUSE_QT5=ON)
		BUILD_DIR="${S}-build_qt5" cmake-utils_src_configure
	fi
}

src_compile() {
	# Build QT4 support #
	BUILD_DIR="${S}-build_qt4" cmake-utils_src_compile

	# Build QT5 support #
	if use qt5; then
		BUILD_DIR="${S}-build_qt5" cmake-utils_src_compile
	fi
}

src_install() {
	# Build QT4 support #
	BUILD_DIR="${S}-build_qt4" cmake-utils_src_install

	# Build QT5 support #
	if use qt5; then
		BUILD_DIR="${S}-build_qt5" cmake-utils_src_install
	fi
}

src_test() {
	local builddir=${CMAKE_BUILD_DIR}

	CMAKE_BUILD_DIR=${CMAKE_BUILD_DIR}/tests \
		VIRTUALX_COMMAND=cmake-utils_src_test virtualmake

	CMAKE_BUILD_DIR=${builddir}
}
