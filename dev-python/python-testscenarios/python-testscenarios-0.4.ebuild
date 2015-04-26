# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/p/${PN}"
URELEASE="vivid"
UVER="3"

DESCRIPTION="Python unittest extension for running tests in different scenarios"
HOMEPAGE="https://launchpad.net/testscenarios"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}/testscenarios-${PV}"
