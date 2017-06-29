# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit autotools cmake-utils multilib ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="API for Unity scopes integration"
HOMEPAGE="https://launchpad.net/unity-scopes-api"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+debug"
RESTRICT="mirror"

DEPEND="dev-cpp/gmock
	dev-libs/boost:=
	dev-libs/capnproto
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/jsoncpp
	dev-libs/libaccounts-glib
	dev-libs/libsignon-glib
	dev-libs/net-cpp
	dev-libs/process-cpp
	dev-libs/userspace-rcu
	dev-util/astyle
	dev-util/cppcheck
	dev-util/lttng-tools[ust]
	dev-util/valgrind
	net-libs/zeromq
	net-libs/zmqpp
	sys-libs/libapparmor
	unity-base/unity-api"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
export CMAKE_BUILD_TYPE=none

src_prepare() {
	ubuntu-versionator_src_prepare

	# CMAKE_LIBRARY_ARCHITECTURE is not set so build tries to write to root filesystem and fails on sandbox violations #
	sed -e 's:${CMAKE_LIBRARY_ARCHITECTURE}/::g' \
		-i test/gtest/scopes/Registry/scopes/testscope{A,B}/CMakeLists.txt || die

	# Gentoo's lsb-release will never match the source's expected output of a Ubuntu system #
	sed -e "s:.*COMMAND lsb_release.*:set(SERIES $URELEASE):g" \
		-i CMakeLists.txt || die
	# Don't install Ubuntu specific package 'version' info file #
	sed '/${CMAKE_CURRENT_BINARY_DIR}\/version/d' \
		-i data/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=(-DCMAKE_BUILD_TYPE="$(usex debug debug)")
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# Delete some files that are only useful on Ubuntu
	rm -rf "${ED}"etc/apport "${ED}"usr/share/apport
}
