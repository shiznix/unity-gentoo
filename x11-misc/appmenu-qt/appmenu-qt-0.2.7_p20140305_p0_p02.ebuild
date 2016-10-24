# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="xenial"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/main/a/${PN}"
UVER_PREFIX="+14.04.${PVR_MICRO}"

DESCRIPTION="Application menu module for Qt"
HOMEPAGE="https://launchpad.net/appmenu-qt"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=dev-qt/qtcore-4.8:4
	>=dev-qt/qtdbus-4.8:4
	>=dev-qt/qtgui-4.8:4
	>=dev-libs/libdbusmenu-qt-0.9.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
DOCS=( NEWS README )

src_configure() {
	mycmakeargs+=(-DUSE_QT4=true)
	cmake-utils_src_configure
}
