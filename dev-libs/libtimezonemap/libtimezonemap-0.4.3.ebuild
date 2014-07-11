# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/libt/${PN}"
UVER=
URELEASE="utopic"

DESCRIPTION="GTK+3 timezone map widget used by the Unity desktop"
HOMEPAGE="https://launchpad.net/libtimezonemap"
SRC_URI="${UURL}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/1.0.0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/json-glib
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3"

#S="${WORKDIR}/timezonemap"

src_prepare() {
	eautoreconf
}
