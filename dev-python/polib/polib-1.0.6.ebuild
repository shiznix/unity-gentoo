# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

URELEASE="vivid"
inherit distutils-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/p/${PN}"
UVER="1"

DESCRIPTION="A library to manipulate gettext files (po and mo files)"
HOMEPAGE="http://bitbucket.org/izi/polib/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="${PYTHON_DEPS}"
