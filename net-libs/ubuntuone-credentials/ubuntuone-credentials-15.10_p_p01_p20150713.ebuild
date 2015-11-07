# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="wily"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"
UVER_SUFFIX="~gcc5.1"

DESCRIPTION="Ubuntu One authentication library"
HOMEPAGE="https://launchpad.net/ubuntuone-credentials"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}${UVER}${UVER_SUFFIX}.tar.xz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	net-libs/liboauth
	unity-base/signon[qt5]
	x11-libs/libaccounts-qt[qt5]"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}${UVER}${UVER_SUFFIX}"
