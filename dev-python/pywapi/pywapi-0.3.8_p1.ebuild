# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_5,3_6} )

URELEASE="artful"
inherit distutils-r1 ubuntu-versionator

UURL="mirror://unity/pool/universe/p/${PN}"
UVER="-${PVR_MICRO}"

DESCRIPTION="Python wrapper around different weather APIs"
HOMEPAGE="https://launchpad.net/python-weather-api"
SRC_URI="https://launchpad.net/python-weather-api/trunk/${PV}/+download/${PN}-${PV}.tar.gz"

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
