# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 ubuntu-versionator

DESCRIPTION="A library to manipulate gettext files (po and mo files)"
HOMEPAGE="http://bitbucket.org/izi/polib/"
SRC_URI="http://bitbucket.org/izi/polib/downloads/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="${PYTHON_DEPS}"
