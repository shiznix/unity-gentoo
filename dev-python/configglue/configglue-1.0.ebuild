# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1
UVER=

DESCRIPTION="Library that glues together python's optparse.OptionParser and ConfigParser.ConfigParser"
HOMEPAGE="https://launchpad.net/configglue"
SRC_URI="mirror://pypi/c/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-python/setuptools"
