# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit eutils distutils-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="saucy"

DESCRIPTION="Ubuntu One file storage and sharing service for the Unity desktop"
HOMEPAGE="https://launchpad.net/ubuntuone-storage-protocol"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/protobuf[python]"
RDEPEND="${DEPEND}
	dev-python/dirspec[${PYTHON_USEDEP}]
	>=dev-python/oauth-1.0[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	>=dev-python/twisted-core-12.2.0[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}
