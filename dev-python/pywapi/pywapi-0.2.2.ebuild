# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
SUPPORT_PYTHON_ABIS="1"

inherit distutils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/p/${PN}"
UVER="1"
URELEASE="raring"
MY_P="${P/-/_}"

DESCRIPTION="Python wrapper around different weather APIs"
HOMEPAGE="https://code.google.com/p/python-weather-api/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate-qt"

src_install() {
	# Delete some files that are only useful on Ubuntu
	rm -rf "${D}"etc/apport "${D}"usr/share/apport

	distutils_src_install
}
