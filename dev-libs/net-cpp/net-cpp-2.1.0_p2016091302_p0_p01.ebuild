# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit cmake-utils flag-o-matic ubuntu-versionator

UURL="mirror://ubuntu/pool/main/n/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="C++11 library for networking processes"
HOMEPAGE="http://launchpad.net/net-cpp"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/boost:=
	dev-libs/jsoncpp
	dev-libs/process-cpp
	net-misc/curl"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	# Disable '-Werror' #
	sed -e 's/-Werror//g' \
		-i CMakeLists.txt
	cmake-utils_src_prepare
}
