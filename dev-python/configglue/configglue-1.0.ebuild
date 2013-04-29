# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2:2.7 3:3.2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils python

DESCRIPTION="Library that glues together python's optparse.OptionParser and ConfigParser.ConfigParser"
HOMEPAGE="https://launchpad.net/configglue"
SRC_URI="mirror://pypi/c/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

pkg_postinst() {
	python_disable_pyc
}
