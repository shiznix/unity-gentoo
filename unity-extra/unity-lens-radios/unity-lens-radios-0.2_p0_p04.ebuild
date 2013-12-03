# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{3_2,3_3} )

inherit distutils-r1 ubuntu-versionator

URELEASE="raring"

DESCRIPTION="Online radio lens used by the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-radios"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="unity-base/unity"
DEPEND="${RDEPEND}
	>=dev-python/python-distutils-extra-2.37
	${PYTHON_DEPS}"
