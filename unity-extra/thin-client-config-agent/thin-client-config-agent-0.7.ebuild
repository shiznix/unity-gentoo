# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.7 3:3.2"
RESTRICT_PYTHON_ABIS="3.*"

inherit ubuntu-versionator distutils eutils

UURL="mirror://ubuntu/pool/main/t/${PN}"
URELEASE="raring"
GNOME2_LA_PUNT="1"
UVER=

DESCRIPTION="Retrieve the list of remote desktop servers for a user."
HOMEPAGE="https://launchpad.net/ubuntu/+source/thin-client-config-agent"
SRC_URI="${UURL}/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-python/pyflakes
	dev-python/pycurl"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install
}
