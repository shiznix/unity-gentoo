# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_3,3_4} )

URELEASE="vivid"
inherit ubuntu-versionator distutils-r1

UURL="mirror://ubuntu/pool/main/t/${PN}"
UVER=

DESCRIPTION="Retrieve the list of remote desktop servers for a user."
HOMEPAGE="https://launchpad.net/ubuntu/+source/thin-client-config-agent"
SRC_URI="${UURL}/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-python/pyflakes[${PYTHON_USEDEP}]
	>=dev-python/pycurl-7.19.0-r3[${PYTHON_USEDEP}]
	dev-python/http-parser
	${PYTHON_DEPS}"

python_install_all() {
	distutils-r1_src_install

	exeinto /usr/bin
	doexe "${S}/thin-client-config-agent"
}
