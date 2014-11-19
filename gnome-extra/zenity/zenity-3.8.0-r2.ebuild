# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/zenity/Attic/zenity-3.8.0-r2.ebuild,v 1.6 2014/11/13 12:15:50 pacho dead $

EAPI="5"
GCONF_DEBUG="yes"

inherit eutils gnome2

DESCRIPTION="Tool to display dialogs from the commandline and shell scripts"
HOMEPAGE="https://wiki.gnome.org/Projects/Zenity"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="libnotify test +webkit"

RDEPEND="
	>=dev-libs/glib-2.8:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3:3
	x11-libs/libX11
	x11-libs/pango
	libnotify? ( >=x11-libs/libnotify-0.6.1:= )
	webkit? ( >=net-libs/webkit-gtk-1.4.0:3 )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.14
	virtual/pkgconfig
	test? ( app-text/yelp-tools )
"
# eautoreconf needs:
#	>=gnome-base/gnome-common-2.12

src_prepare() {
	# Fix double clicking an item or hitting enter after selecting an item (from 'master')
	epatch "${FILESDIR}/${PN}-3.8.0-double-click.patch"

	# Fix the broken auto-close option in progress and list dialogs (from 'master')
	epatch "${FILESDIR}/${PN}-3.8.0-broken-autoclose.patch"

	# List box doesn't expand to fill window (from 'master')
	epatch "${FILESDIR}/${PN}-3.8.0-listbox-expand.patch"

	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README THANKS TODO"

	gnome2_src_configure \
		$(use_enable libnotify) \
		$(use_enable webkit webkitgtk) \
		PERL=$(type -P false) \
		ITSTOOL=$(type -P true)
}

src_install() {
	gnome2_src_install

	rm "${ED}/usr/bin/gdialog" || die "rm gdialog failed!"
}
