# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2:2.7 3:3.2"
SUPPORT_PYTHON_ABIS="1"

inherit cmake-utils eutils python ubuntu-versionator

UURL="mirror://ubuntu/pool/main/libc/${PN}"
URELEASE="saucy"
UVER_PREFIX="daily13.06.06"

DESCRIPTION="Error tolerant matching engine used by the Unity desktop"
HOMEPAGE="https://launchpad.net/libcolombus"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0/0.4.0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-cpp/sparsehash
	dev-libs/boost
	>=dev-libs/icu-49.1.2"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
