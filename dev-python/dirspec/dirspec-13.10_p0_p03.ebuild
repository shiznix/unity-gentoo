# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/d/${PN}"
URELEASE="vivid"

DESCRIPTION="Python User Folders Specification Library"
HOMEPAGE="https://launchpad.net/dirspec"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
