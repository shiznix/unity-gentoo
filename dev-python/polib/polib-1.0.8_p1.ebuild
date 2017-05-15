# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

URELEASE="zesty"
inherit distutils-r1 ubuntu-versionator

UURL="mirror://unity/pool/main/p/${PN}"
UVER="-${PVR_MICRO}"

DESCRIPTION="A library to manipulate gettext files (po and mo files)"
HOMEPAGE="http://bitbucket.org/izi/polib/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="${PYTHON_DEPS}"
