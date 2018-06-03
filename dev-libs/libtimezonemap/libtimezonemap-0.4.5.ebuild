# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="bionic"
inherit autotools eutils gnome2-utils ubuntu-versionator

UVER=

DESCRIPTION="GTK+3 timezone map widget used by the Unity desktop"
HOMEPAGE="https://launchpad.net/libtimezonemap"
SRC_URI="${UURL}/${MY_P}${UVER}.tar.gz"

LICENSE="GPL-2"
SLOT="0/1.0.0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/json-glib
	net-libs/libsoup
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3"

S="${WORKDIR}/${PN}-${PV}${UVER}"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_install() {
	default
	prune_libtool_files --modules

}
