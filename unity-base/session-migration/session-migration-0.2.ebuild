# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
#VALA_MIN_API_VERSION="0.20"
#VALA_USE_DEPEND="vapigen"

inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/s/${PN}"
URELEASE="saucy"

DESCRIPTION="Tool to migrate in user session settings used by the Unity desktop"
HOMEPAGE="https://launchpad.net/session-migration"
SRC_URI="${UURL}/${MY_P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2"
