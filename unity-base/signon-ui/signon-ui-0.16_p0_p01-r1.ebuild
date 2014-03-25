# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/main/s/${PN}"
URELEASE="trusty"
UVER_PREFIX="+14.04.20140304.is.0.15+14.04.20140313"

DESCRIPTION="Single Sign On framework for the Unity desktop"
HOMEPAGE="https://launchpad.net/signon-ui"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

RDEPEND="x11-libs/libaccounts-qt:="
DEPEND="${RDEPEND}
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtsql:5
	dev-qt/qtxmlpatterns:5
	dev-qt/qtwebkit:5
	net-libs/libproxy
	unity-base/signon[qt5]
	x11-libs/libnotify"
