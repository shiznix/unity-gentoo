# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="hirsute"
inherit cmake-utils ubuntu-versionator

UVER_PREFIX="+bzr49+repack${PVR_PL_MAJOR}"
UVER="-${PVR_PL_MINOR}"

DESCRIPTION="Qt Bindings for python-dbusmock"
HOMEPAGE="https://launchpad.net/libqtdbustest"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.xz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

# Networkmanager >1.20 removes NetworkManager.pc and libnm-{util,glib,glib-vpn}.pc #
DEPEND=">=dev-cpp/gtest-1.8.1
	dev-libs/libqtdbustest
	net-misc/networkmanager"

S="${S}+bzr49"

PATCHES=( "${FILESDIR}"/1001_port-to-libnm.patch )

src_prepare() {
	ubuntu-versionator_src_prepare

	# Disable build of tests #
	sed '/add_subdirectory(tests)/d' -i CMakeLists.txt || die
	cmake-utils_src_prepare
}
