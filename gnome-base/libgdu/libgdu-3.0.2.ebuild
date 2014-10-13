# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgdu/libgdu-3.0.2.ebuild,v 1.11 2012/10/28 15:52:33 armin76 Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_ORG_MODULE="gnome-disk-utility"

inherit autotools eutils gnome2

DESCRIPTION="GNOME Disk Utility libraries"
HOMEPAGE="http://git.gnome.org/browse/gnome-disk-utility"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="avahi doc gnome-keyring"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sh sparc x86"

CDEPEND="
	>=dev-libs/glib-2.22:2
	>=dev-libs/dbus-glib-0.74
	>=x11-libs/gtk+-2.90.7:3
	=sys-fs/udisks-1.0*:0
	>=dev-libs/libatasmart-0.14
	>=x11-libs/libnotify-0.6.1

	avahi? ( >=net-dns/avahi-0.6.25[gtk3] )
	gnome-keyring? ( gnome-base/libgnome-keyring )
"
RDEPEND="${CDEPEND}
	!<=sys-apps/gnome-disk-utility-3.0.2-r200
	!=sys-apps/gnome-disk-utility-3.0.2-r300"
# libgdu was part of gnome-disk-utility until 3.0.2-r{200,300}
DEPEND="${CDEPEND}
	sys-devel/gettext
	gnome-base/gnome-common
	app-text/docbook-xml-dtd:4.1.2
	app-text/gnome-doc-utils

	virtual/pkgconfig
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.13

	doc? ( >=dev-util/gtk-doc-1.3 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable avahi avahi-ui)
		$(use_enable gnome-keyring)"
	DOCS="AUTHORS NEWS README TODO"
}

src_prepare() {
	local f=data/gdu-notification-daemon.desktop.in.in.in
	sed -i -e '/^OnlyShowIn/d' ${f} || die
	echo 'NotShowIn=KDE;' >> ${f}

	# gold underlinking detection
	epatch "${FILESDIR}"/${P}-gold.patch

	# Palimpsest and Nautilus plugin are provided by sys-apps/gnome-disk-utility
	epatch "${FILESDIR}/${PN}-3.0.2-no-palimpsest-nautilus.patch"

	# Keep avahi optional, upstream bug #631986
	epatch "${FILESDIR}/${PN}-3.0.2-optional-avahi.patch"
	intltoolize --force --copy --automake || die
	eautoreconf

	gnome2_src_prepare
}
