# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

URELEASE="yakkety"
inherit distutils-r1 ubuntu-versionator

UURL="mirror://unity/pool/main/p/${PN}"
UVER="-${PVR_MICRO}"

DESCRIPTION="Python unittest extension for running tests in different scenarios"
HOMEPAGE="https://launchpad.net/testscenarios"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}/testscenarios-${PV}"
