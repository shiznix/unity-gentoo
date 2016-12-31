# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/p/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Service to allow requesting payment for an item"
HOMEPAGE="http://launchpad.net/pay-service"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/go
	dev-libs/glib:2
	dev-libs/process-cpp
	dev-libs/properties-cpp
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	net-libs/ubuntuone-credentials
	net-misc/curl
	sys-apps/click
	sys-apps/ubuntu-app-launch
	x11-libs/libaccounts-qt"

S="${WORKDIR}"
