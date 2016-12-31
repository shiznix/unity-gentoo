# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/i/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Systems settings menu service - Network indicator"
HOMEPAGE="https://launchpad.net/indicator-network"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="app-crypt/libsecret
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	net-misc/networkmanager
	net-misc/ofono
	net-misc/url-dispatcher
	x11-libs/libqofono
	x11-themes/ubuntu-themes"

S="${WORKDIR}"
export QT_SELECT=5

src_configure() {
	# FIXME: Tests requires a 'gmenuharness' ebuild #
	mycmakeargs+=(-DENABLE_TESTS=FALSE)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	# Remove all installed language files as they can be incomplete #
	# due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"
}
