# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="utopic-updates"
inherit ubuntu-versionator

UURL="mirror://ubuntu/pool/main/c/${PN}"

DESCRIPTION="Central cgroup manager daemon"
HOMEPAGE="https://launchpad.net/cgmanager"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="sys-apps/dbus
	sys-apps/help2man
	sys-libs/libnih"
