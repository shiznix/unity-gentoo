# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://github.com/darkxst/${PN}.git"

inherit autotools git-2

DESCRIPTION="Unity monitor display config"
HOMEPAGE="https://github.com/darkxst/displayconfig"
LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"

src_prepare() {
	eautoreconf
}
