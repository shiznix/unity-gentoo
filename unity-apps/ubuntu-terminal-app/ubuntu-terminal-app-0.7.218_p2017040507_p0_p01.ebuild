# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Unity8 Terminal application"
HOMEPAGE="https://launchpad.net/ubuntu-terminal-app"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtsystems:5
	x11-libs/ubuntu-ui-toolkit"

S="${WORKDIR}/${PN}-${UVER_PREFIX}${UVER}"
export QT_SELECT=5

src_configure() {
	mycmakeargs+=(-DCLICK_MODE=OFF)
	cmake-utils_src_configure
}
