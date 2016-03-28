# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

URELEASE="wily"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/d/${PN}"

DESCRIPTION="Dbus-binding leveraging C++-11"
HOMEPAGE="http://launchpad.net/dbus-cpp"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"
RESTRICT="mirror"

DEPEND="dev-cpp/gtest
	dev-libs/boost:=
	dev-libs/process-cpp
	sys-apps/dbus"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	use doc || \
		sed -i 's:add_subdirectory(doc)::g' \
			-i CMakeLists.txt

	use examples || \
		sed -i 's:add_subdirectory(examples)::g' \
			-i CMakeLists.txt

	use test || \
		sed -i 's:add_subdirectory(test)::g' \
			-i CMakeLists.txt

	# Disable '-Werror' #
	sed -e 's/-Werror//g' \
		-i CMakeLists.txt
}
