# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
#PYTHON_COMPAT=( python{2_7,3_2,3_3} )

#inherit cmake-utils eutils python-r1 ubuntu-versionator
inherit ubuntu-versionator

UURL="mirror://ubuntu/pool/main/c/${PN}"
URELEASE="utopic"
UVER_PREFIX=

DESCRIPTION="Error tolerant matching engine used by the Unity desktop"
HOMEPAGE="https://launchpad.net/cgmanager"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="
	sys-apps/dbus
	sys-apps/help2man
	sys-libs/libnih
"
