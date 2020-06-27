# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="focal"
inherit cmake-utils ubuntu-versionator

UVER_PREFIX="+bzr49+repack${PVR_MICRO}"
UVER="-${PVR_PL_MAJOR}build${PVR_PL_MINOR}"

DESCRIPTION="Qt Bindings for python-dbusmock"
HOMEPAGE="https://launchpad.net/libqtdbustest"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND=">=dev-cpp/gtest-1.8.1
	dev-libs/libqtdbustest
	net-misc/networkmanager"

S="${S}+bzr49"

src_prepare() {
	ubuntu-versionator_src_prepare
	# Include missing glib-2.0 header files for building with >=networkmanager-1.0.6 #
	sed -e 's:NetworkManager REQUIRED:NetworkManager REQUIRED glib-2.0 REQUIRED:g' \
		-i CMakeLists.txt

	# Disable build of tests #
	sed '/add_subdirectory(tests)/d' -i CMakeLists.txt || die
	cmake-utils_src_prepare
}
