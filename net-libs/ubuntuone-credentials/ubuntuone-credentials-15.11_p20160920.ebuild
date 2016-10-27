# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/main/u/${PN}"
UVER="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Ubuntu One authentication library"
HOMEPAGE="https://launchpad.net/ubuntuone-credentials"
SRC_URI="${UURL}/${MY_P}${UVER}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	net-libs/liboauth
	unity-base/signon[qt5]
	x11-libs/libaccounts-qt"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}${UVER}${UVER_SUFFIX}"
unset QT_QPA_PLATFORMTHEME

src_prepare() {
	ubuntu-versionator_src_prepare
	# Fix sandbox violation #
	sed -e "s:\${CMAKE_INSTALL_PREFIX}:${ED}\${CMAKE_INSTALL_PREFIX}:g" \
		-i qml-credentials-service/CMakeLists.txt || die
	cmake-utils_src_prepare
}
