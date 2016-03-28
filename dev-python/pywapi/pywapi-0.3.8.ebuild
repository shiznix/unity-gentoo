# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

URELEASE="wily"
inherit distutils-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/p/${PN}"
UVER="1"

DESCRIPTION="Python wrapper around different weather APIs"
HOMEPAGE="https://launchpad.net/python-weather-api"
SRC_URI="https://launchpad.net/python-weather-api/trunk/0.3.8/+download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate-qt
	${PYTHON_DEPS}"

src_install() {
	# Delete some files that are only useful on Ubuntu
	rm -rf "${D}"etc/apport "${D}"usr/share/apport

	distutils-r1_src_install
}
