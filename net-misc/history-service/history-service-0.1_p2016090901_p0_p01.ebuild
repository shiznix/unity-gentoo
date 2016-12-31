# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit cmake-utils multilib ubuntu-versionator

UURL="mirror://ubuntu/pool/main/h/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="History service to store messages and calls for Ubuntu"
HOMEPAGE="https://launchpad.net/history-service"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-db/sqlite:3
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtpim:5
	dev-qt/qtsql:5
	media-libs/qt-gstreamer[qt5]
	net-libs/libphonenumber
	net-libs/telepathy-qt[qt5]"

S="${WORKDIR}"
export QT_SELECT=5

src_prepare() {
	ubuntu-versionator_src_prepare
	# Don't build tests as they fail to compile #
	sed -i '/add_subdirectory(tests)/d' "${S}/CMakeLists.txt" || die
	cmake-utils_src_prepare
}
