# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="wily"
inherit autotools eutils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/i/${PN}"
UVER_PREFIX="+15.04.${PVR_MICRO}"

DESCRIPTION="Gnome panel indicator for the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-applet"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-2.1 LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libindicator:3
	x11-libs/gtk+:3
	gnome-base/gnome-panel"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	# some API is declared as deprecated in gtk+ 3.10
	epatch "${FILESDIR}/remove_GTK_DISABLE_DEPRECATED.patch"

	# "Only <glib.h> can be included directly." #
	sed -e "s:glib/gtypes.h:glib.h:g" \
		-i src/tomboykeybinder.h
	eautoreconf
}
