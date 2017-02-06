# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/p/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Implementation of the Platform API for a Mir server"
HOMEPAGE="https://launchpad.net/platform-api"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="app-misc/location-service
	dev-libs/boost:=
	dev-libs/dbus-cpp
	mir-base/mir
	net-misc/url-dispatcher
	sys-apps/dbus"

S="${WORKDIR}"
