# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="artful"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/universe/libq/${PN}"
UVER_PREFIX="+17.04.${PVR_MICRO}"

DESCRIPTION="Library to facilitate testing DBus interactions in Qt applications"
HOMEPAGE="https://launchpad.net/libqtdbustest"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

S="${WORKDIR}"

DEPEND="dev-cpp/gmock
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qttest:5
	dev-util/cmake-extras"
