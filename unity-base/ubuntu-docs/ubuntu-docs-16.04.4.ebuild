# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

## Keep at Xenial as it's the last version that contains Unity Help ##
#URELEASE="xenial"
inherit autotools eutils gnome2-utils ubuntu-versionator

UVER=

DESCRIPTION="Help files for the Unity desktop"
HOMEPAGE="https://launchpad.net/ubuntu-docs"
SRC_URI="${UURL}/${MY_P}.tar.xz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# This ebuild does not install any binaries
RESTRICT="binchecks mirror strip"

DEPEND="app-text/gnome-doc-utils
	app-text/yelp-tools
	dev-libs/libxml2
	gnome-extra/yelp"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}
