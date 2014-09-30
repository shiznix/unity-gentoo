# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-calculator/Attic/gnome-calculator-3.10.2.ebuild,v 1.6 2014/09/30 10:36:58 pacho dead $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A calculator application for GNOME"
HOMEPAGE="https://live.gnome.org/Calculator"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"

COMMON_DEPEND="
	>=x11-libs/gtk+-3:3
	>=dev-libs/glib-2.31:2
	dev-libs/libxml2:2
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/gnome-utils-2.3
	!gnome-extra/gcalctool
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		ITSTOOL=$(type -P true) \
		VALAC=$(type -P true)
}
