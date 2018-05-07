# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="bionic"
inherit cmake-multilib multibuild multilib virtualx ubuntu-versionator

UVER_PREFIX="+16.04.${PVR_MICRO}"

DESCRIPTION="A library providing Qt implementation of DBusMenu specification"
HOMEPAGE="https://launchpad.net/libdbusmenu-qt/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"
#KEYWORDS="~amd64 ~x86"

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug doc +qt4 qt5"
# tests fail due to missing connection to dbus
RESTRICT="mirror test"

RDEPEND="dev-libs/qjson
	>=dev-qt/qttest-4.8.6:4[${MULTILIB_USEDEP}]
	qt4? (
		>=dev-qt/qtcore-4.8.6:4[${MULTILIB_USEDEP}]
		>=dev-qt/qtdbus-4.8.6:4[${MULTILIB_USEDEP}]
		>=dev-qt/qtgui-4.8.6:4[${MULTILIB_USEDEP}]
	)
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qttest:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"
REQUIRED_USE="|| ( qt4 qt5 )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
DOCS=( NEWS README )

pkg_setup() {
	ubuntu-versionator_pkg_setup
	MULTIBUILD_VARIANTS=( $(usex qt4 4) $(usex qt5 5) )
}

src_prepare() {
	ubuntu-versionator_src_prepare
	cmake-utils_src_prepare
	cmake_comment_add_subdirectory tools
	cmake_comment_add_subdirectory tests
}

multilib_src_configure() {
	local mycmakeargs+=( -DBUILD_TESTS="$(usex test)"
				-DWITH_DOC="$(usex doc)"
				-DUSE_QT${QT_MULTIBUILD_VARIANT}=ON
				-DQT_QMAKE_EXECUTABLE="/usr/$(get_libdir)/qt${QT_MULTIBUILD_VARIANT}/bin/qmake"
	)
	cmake-utils_src_configure
}

src_configure() {
	myconfigure() {
		local QT_MULTIBUILD_VARIANT=${MULTIBUILD_VARIANT}
		if [[ ${MULTIBUILD_VARIANT} = 4 ]] ; then
			cmake-multilib_src_configure
		elif [[ ${MULTIBUILD_VARIANT} = 5 ]] ; then
			multilib_src_configure
		fi
	}
	multibuild_foreach_variant myconfigure
}

src_compile() {
	mycompile() {
		if [[ ${MULTIBUILD_VARIANT} = 4 ]] ; then
			cmake-multilib_src_compile
		elif [[ ${MULTIBUILD_VARIANT} = 5 ]] ; then
			cmake-utils_src_compile
		fi
	}
	multibuild_foreach_variant mycompile
}

src_install() {
	myinstall() {
		if [[ ${MULTIBUILD_VARIANT} = 4 ]] ; then
			cmake-multilib_src_install
		elif [[ ${MULTIBUILD_VARIANT} = 5 ]] ; then
			cmake-utils_src_install
		fi
	}
	multibuild_foreach_variant myinstall
}

src_test() {
	mytest() {
		if [[ ${MULTIBUILD_VARIANT} = 4 ]] ; then
			cmake-multilib_src_test
		elif [[ ${MULTIBUILD_VARIANT} = 5 ]] ; then
			multilib_src_test
		fi
	}
	multibuild_foreach_variant mytest
}

multilib_src_test() {
	local builddir=${BUILD_DIR}

	BUILD_DIR=${BUILD_DIR}/tests \
	VIRTUALX_COMMAND=cmake-utils_src_test virtualmake

	BUILD_DIR=${builddir}
}
