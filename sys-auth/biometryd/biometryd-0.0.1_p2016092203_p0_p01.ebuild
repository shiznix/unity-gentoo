# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/b/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Multiplexes and mediates access to devices for biometric identification and verification"
HOMEPAGE="http://launchpad.net/biometryd"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-db/sqlite:3
	dev-libs/boost:=
	dev-libs/dbus-cpp
	dev-libs/process-cpp
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	sys-apps/dbus
	sys-libs/libapparmor"

S="${WORKDIR}"
export QT_SELECT=5
unset QT_QPA_PLATFORMTHEME

src_configure() {
	mycmakeargs+=(-DBIOMETRYD_VERSION_MAJOR=1
			-DBIOMETRYD_VERSION_MINOR=0
			-DBIOMETRYD_VERSION_PATCH=1)
	cmake-utils_src_configure
}
