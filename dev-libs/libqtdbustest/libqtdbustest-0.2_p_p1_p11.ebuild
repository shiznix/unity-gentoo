# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="hirsute"
inherit cmake-utils ubuntu-versionator

UVER_PREFIX="+bzr42+repack${PVR_PL_MAJOR}"
UVER="-${PVR_PL_MINOR}"

# Tarball not available at traditional Launchpad location #
UURL="https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/libqtdbustest/${PV}${UVER_PREFIX}${UVER}"

DESCRIPTION="Library to facilitate testing DBus interactions in Qt applications"
HOMEPAGE="https://launchpad.net/libqtdbustest"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.xz
	${UURL}/${MY_P}${UVER_PREFIX}${UVER}.debian.tar.xz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}+bzr42"

# Won't build with >dev-cpp/gtest-1.8 "no rule to make target libgtest.a"
DEPEND="=dev-cpp/gtest-1.8*
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qttest:5
	dev-util/cmake-extras"

src_prepare() {
	cmake-utils_src_prepare
	ubuntu-versionator_src_prepare
}