# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/q/${PN}"
UVER_PREFIX="+16.04.${PVR_MICRO}"

DESCRIPTION="GMenuModel Qt bindings"
HOMEPAGE="https://launchpad.net/qmenumodel"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	test? ( dev-qt/qttest:5
		dev-util/dbus-test-runner )"

S="${WORKDIR}"
export QT_SELECT=5
