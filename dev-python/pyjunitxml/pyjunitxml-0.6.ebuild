# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_3} )

URELEASE="wily"
inherit distutils-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/p/${PN}"
UVER="1.1build1"

DESCRIPTION="PyUnit extension for reporting in JUnit compatible XML"
HOMEPAGE="https://launchpad.net/pyjunitxml"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}/junitxml-${PV}"
