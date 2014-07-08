# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/u/${PN}"
URELEASE="trusty"
UVER_PREFIX="+14.04.20140313"

DESCRIPTION="Qt/QML implementation of U1DB"
HOMEPAGE="https://launchpad.net/u1db-qt"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/u1db
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
        dev-qt/qtnetwork:5
        dev-qt/qtsql:5[sqlite]"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
export PATH="/usr/$(get_libdir)/qt5/bin:${PATH}"	# Need to see QT5's qmlplugindump
