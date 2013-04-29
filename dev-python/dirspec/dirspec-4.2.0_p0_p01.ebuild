# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.7 3:3.2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/d/${PN}"
URELEASE="raring"

DESCRIPTION="Python User Folders Specification Library"
HOMEPAGE="https://launchpad.net/dirspec"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
