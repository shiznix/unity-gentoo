# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

inherit eutils gnome2 ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/d/${PN}"
URELEASE="saucy"

DESCRIPTION="Simple backup tool using duplicity back-end"
HOMEPAGE="https://launchpad.net/deja-dup/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+nautilus"
RESTRICT="mirror test"

COMMON_DEPEND="
	app-crypt/libsecret[vala]
	dev-libs/libdbusmenu:=
	dev-libs/libunity:=
	dev-libs/glib:2
	dev-libs/libpeas
	gnome-base/gnome-control-center
	x11-libs/gtk+:3
	x11-libs/libnotify

	app-backup/duplicity
	dev-libs/dbus-glib

	nautilus? ( gnome-base/nautilus )"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gvfs[fuse]"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-perl/Locale-gettext
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext
	$(vala_depend)"

src_prepare() {
	DOCS="NEWS AUTHORS"
	G2CONF="${G2CONF}
		$(use_with nautilus)
		--with-ccpanel
		--with-unity
		--disable-static"
	vala_src_prepare
	gnome2_src_prepare
}
