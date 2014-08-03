# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/libq/${PN}"
URELEASE="utopic"
UVER_PREFIX="+14.10.20140730"

DESCRIPTION="Qt Bindings for python-dbusmock"
HOMEPAGE="https://launchpad.net/libqtdbustest"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

DEPEND="
	dev-cpp/gmock
	dev-libs/libqtdbustest
	net-misc/networkmanager
"

src_prepare() {
        # disable build of tests
        sed -i '/add_subdirectory(tests)/d' "${S}/CMakeLists.txt" || die
}
