# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-r2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/s/${PN}"
URELEASE="saucy"
UVER_PREFIX="+13.10.20131016.2"

DESCRIPTION="Single Sign On framework for the Unity desktop"
HOMEPAGE="https://launchpad.net/signon-ui"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="x11-libs/libaccounts-qt:="
DEPEND="${RDEPEND}
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qtsql:4
	dev-qt/qtxmlpatterns:4
	dev-qt/qtwebkit:4
	net-libs/libproxy
	unity-base/signon
	x11-libs/libnotify"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
QT5_BUILD_DIR="${S}"
