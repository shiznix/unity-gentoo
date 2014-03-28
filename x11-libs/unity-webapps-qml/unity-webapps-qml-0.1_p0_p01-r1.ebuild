# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="trusty"
UVER_PREFIX="+14.04.20140321.1"

DESCRIPTION="Unity Webapps QML component"
HOMEPAGE="https://launchpad.net/unity-webapps-qml"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib
	dev-libs/libunity
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5
	unity-base/hud
	unity-indicators/indicator-messages
	x11-libs/accounts-qml-module
	x11-libs/libnotify
	x11-libs/ubuntu-ui-toolkit
	x11-libs/unity-action-api"

S=${WORKDIR}/${PN}-${PV}${UVER_PREFIX}
export PATH="${PATH}:/usr/$(get_libdir)/qt5/bin"
