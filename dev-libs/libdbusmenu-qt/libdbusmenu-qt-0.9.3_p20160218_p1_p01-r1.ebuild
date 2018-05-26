# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="bionic"
inherit cmake-multilib multibuild multilib virtualx ubuntu-versionator

UVER_PREFIX="+16.04.${PVR_MICRO}"

DESCRIPTION="A library providing Qt implementation of DBusMenu specification"
HOMEPAGE="https://launchpad.net/libdbusmenu-qt/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug doc"
# tests fail due to missing connection to dbus
RESTRICT="mirror test"

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qttest:5
	dev-qt/qtwidgets:5"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
DOCS=( NEWS README )
export QT_SELECT=5

src_prepare() {
	ubuntu-versionator_src_prepare
	cmake-utils_src_prepare
	cmake_comment_add_subdirectory tools
	cmake_comment_add_subdirectory tests
}

src_configure() {
	local mycmakeargs+=( -DWITH_DOC="$(usex doc)"
				-DUSE_QT4=OFF
				-DUSE_QT5=ON
	)
	cmake-multilib_src_configure
}

src_test() {
	cmake-multilib_src_test
}
