# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_2,3_3} )

inherit cmake-utils eutils python-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/libc/${PN}"
URELEASE="trusty"
UVER_PREFIX="+14.04.20140325.3"

DESCRIPTION="Error tolerant matching engine used by the Unity desktop"
HOMEPAGE="https://launchpad.net/libcolombus"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0/0.4.0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-cpp/sparsehash
	dev-libs/boost[${PYTHON_USEDEP}]
	>=dev-libs/icu-49.1.2
	${PYTHON_DEPS}"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
