# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 ubuntu-versionator

MY_PN="lazr.restfulclient"
UURL="mirror://ubuntu/pool/main/l/${MY_PN}"
UVER="1build1"
URELEASE="trusty"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Client for lazr.restful-based web services for the Unity desktop"
HOMEPAGE="https://launchpad.net/lazr.restfulclient"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/oauth[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	net-zope/zope-interface[${PYTHON_USEDEP}]"

S="${WORKDIR}/lazr.restfulclient-${PV}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}
