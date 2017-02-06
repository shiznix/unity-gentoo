# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/main/u/${PN}"
UVER_PREFIX="${PV}"

DESCRIPTION="Unity8 Terminal application"
HOMEPAGE="https://launchpad.net/ubuntu-terminal-app"
SRC_URI="${UURL}/${PN}_${UVER_PREFIX}${UVER}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
