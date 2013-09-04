# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_2,3_3} )

inherit distutils-r1 ubuntu-versionator

UVER=
UURL="mirror://ubuntu/pool/universe/p/${PN}"
URELEASE="saucy"
UVER_PREFIX="~svn147.orig"
MY_P="${P/-/_}"

DESCRIPTION="Python wrapper around different weather APIs"
HOMEPAGE="https://code.google.com/p/python-weather-api/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.tar.gz"
S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate-qt"

src_install() {
	# Delete some files that are only useful on Ubuntu
	rm -rf "${D}"etc/apport "${D}"usr/share/apport

	distutils-r1_src_install
}
