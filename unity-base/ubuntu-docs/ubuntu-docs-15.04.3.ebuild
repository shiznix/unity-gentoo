# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

URELEASE="vivid-updates"
inherit autotools eutils gnome2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
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
	eautoreconf
}
