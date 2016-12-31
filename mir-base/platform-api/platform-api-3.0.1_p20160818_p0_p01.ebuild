# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/p/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Implementation of the Platform API for a Mir server"
HOMEPAGE="https://launchpad.net/platform-api"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="app-misc/location-service
	dev-libs/boost:=
	dev-libs/dbus-cpp
	mir-base/mir
	net-misc/url-dispatcher
	sys-apps/dbus"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	# Strip/disable android related hybris support #
	sed -e 's:add_subdirectory(touch)::g' \
		-i src/ubuntu/application/CMakeLists.txt
	sed -e 's:add_subdirectory(hardware)::g' \
		-i src/ubuntu/CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=(-DENABLE_MIRSERVER_IMPLEMENTATION=ON
		-DENABLE_MIRCLIENT_IMPLEMENTATION=ON)
	cmake-utils_src_configure

	# Ubuntu's 'pkg-config --cflags ...' outputs 'Requires:' first, and 'Cflags:' last #
	# Gentoo's 'pkg-config --cflags ...' outputs 'Cflags:' first, and 'Requires:' last #
	#  Re-order to what the source expects #
	sed -e 's:\(.*\)=\(.*dbus-cpp-0;\)\(.*\):\1=\3;\2:g' \
		-e 's:;$::g' \
			-i "${BUILD_DIR}"/CMakeCache.txt
}
