# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/universe/libq/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Qt Bindings for python-dbusmock"
HOMEPAGE="https://launchpad.net/libqtdbustest"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

S="${WORKDIR}"

DEPEND="dev-cpp/gmock
	dev-libs/libqtdbustest
	net-misc/networkmanager"

src_prepare() {
	ubuntu-versionator_src_prepare
	# Include missing glib-2.0 header files for building with >=networkmanager-1.0.6 #
	sed -e 's:NetworkManager REQUIRED:NetworkManager REQUIRED glib-2.0 REQUIRED:g' \
		-i CMakeLists.txt

	# Disable build of tests #
	sed '/add_subdirectory(tests)/d' -i CMakeLists.txt || die
	cmake-utils_src_prepare
}
