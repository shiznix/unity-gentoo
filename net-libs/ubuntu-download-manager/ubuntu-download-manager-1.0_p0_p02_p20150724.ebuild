# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="wily"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"
UVER_SUFFIX="~ppa2"

DESCRIPTION="A daemon that offers a DBus API to perform downloads"
HOMEPAGE="https://launchpad.net/ubuntu-download-manager"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="mirror"

DEPEND="dev-cpp/glog
	dev-cpp/gmock
	dev-libs/boost:=
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qttest:5
	dev-qt/qtsystems:5
	sys-apps/dbus
	sys-libs/libnih"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
export QT_SELECT=5

src_prepare() {
	ubuntu-versionator_src_prepare
	use test || \
		sed -e '/add_subdirectory(tests)/d' \
			-i CMakeLists.txt
	use doc || \
		sed -e '/add_subdirectory(docs)/d' \
			-i CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=(-DCMAKE_INSTALL_LIBEXECDIR=/usr/lib)
	cmake-utils_src_configure
}
