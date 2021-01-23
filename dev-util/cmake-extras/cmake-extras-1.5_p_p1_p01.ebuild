# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="groovy"
inherit cmake-utils ubuntu-versionator

DESCRIPTION="Extra CMake utility modules"
HOMEPAGE="http://launchpad.net/cmake-extras"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
