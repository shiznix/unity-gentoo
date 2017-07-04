# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/main/t/${PN}"
UVER_PREFIX="+16.04.${PVR_MICRO}"

DESCRIPTION="API for creating, reading, updating and deleting trust requests answered by users"
HOMEPAGE="http://launchpad.net/trust-store"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-cpp/glog
	dev-db/sqlite:3
	dev-libs/boost:=
	dev-libs/dbus-cpp
	dev-libs/process-cpp
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	mir-base/mir"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	epatch -p1 "${FILESDIR}/stdcerr_iostream-fix.diff"

	# Disable warnings being treated as errors #
	sed -e 's:-Werror ::g' \
		-i CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=(-DTRUST_STORE_VERSION_MAJOR=2)
	cmake-utils_src_configure
}
