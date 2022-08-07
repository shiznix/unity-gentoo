# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="jammy"
inherit cmake ubuntu-versionator

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
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}+bzr42"

DEPEND="dev-cpp/gtest
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qttest:5
	dev-util/cmake-extras"

src_prepare() {
	# Fix build with >dev-cpp/gtest-1.8 "no rule to make target libgtest.a"
	sed -i \
		-e "/find_package/{s/GMock/GTest/}" \
		tests/CMakeLists.txt

	cmake_src_prepare
	ubuntu-versionator_src_prepare
}
