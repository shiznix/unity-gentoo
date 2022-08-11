# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="jammy"
inherit cmake ubuntu-versionator

UVER="-${PV}${PVR_PL_MINOR}"

DESCRIPTION="CMake utility modules needed for building Vala Panel "
HOMEPAGE="https://gitlib.com/vala-panel-project/cmake-vala"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-r${PV}"
