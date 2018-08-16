# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="artful"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/universe/d/${PN}"
UVER_PREFIX="+16.10.${PVR_MICRO}"

DESCRIPTION="Dbus-binding leveraging C++-11"
HOMEPAGE="http://launchpad.net/dbus-cpp"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"
RESTRICT="mirror"

DEPEND="doc? ( app-doc/doxygen )
        test? ( dev-cpp/gmock )
        dev-cpp/gtest
	dev-libs/boost:=
	dev-libs/process-cpp
	sys-apps/dbus"

S="${WORKDIR}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	ubuntu-versionator_src_prepare
	use doc || \
		sed -i 's:add_subdirectory(doc)::g' \
			-i CMakeLists.txt

	use examples || \
		sed -i 's:add_subdirectory(examples)::g' \
			-i CMakeLists.txt

	use test || \
		sed -i 's:add_subdirectory(tests)::g' \
			-i CMakeLists.txt

	# Fix build errors using >=gcc-5.4.0 #
#	epatch -p1 "${FILESDIR}/dbus-cpp_fix-missing-random-include_LP1592814.diff"

	# Disable '-Werror' #
	sed -e 's/-Werror//g' \
		-i CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=(-DDBUS_CPP_VERSION_MAJOR=5)
	cmake-utils_src_configure
}
