# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit qt5-build ubuntu-versionator

UURL="mirror://unity/pool/main/s/${PN}"
UVER_PREFIX="+16.04.${PVR_MICRO}"

DESCRIPTION="Single Sign On framework for the Unity desktop"
HOMEPAGE="https://launchpad.net/signon-ui"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtnetwork:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qttest:5
	dev-qt/qtxmlpatterns:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	net-libs/libproxy[-kde]
	unity-base/signon
	x11-libs/libaccounts-qt:=
	x11-libs/libnotify"

S="${WORKDIR}"
QT5_BUILD_DIR="${S}"
