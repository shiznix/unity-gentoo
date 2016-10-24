# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GCONF_DEBUG="yes"

URELEASE="xenial"
inherit autotools gnome2-utils ubuntu-versionator

UURL="mirror://unity/pool/main/g/${PN}"

DESCRIPTION="GNOME framework for accessing online accounts"
HOMEPAGE="https://wiki.gnome.org/GnomeOnlineAccounts"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"
LICENSE="LGPL-2+"
SLOT="0/1"
IUSE="gnome +introspection kerberos uoa"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

# pango used in goaeditablelabel
# libsoup used in goaoauthprovider
# goa kerberos provider is incompatible with app-crypt/heimdal, see
# https://bugzilla.gnome.org/show_bug.cgi?id=692250
# json-glib-0.16 needed for bug #485092
RDEPEND="
	>=dev-libs/glib-2.35:2
	>=app-crypt/libsecret-0.5
	>=dev-libs/json-glib-0.16
	dev-libs/libxml2:2
	>=net-libs/libsoup-2.42:2.4
	net-libs/rest:0.7
	net-libs/telepathy-glib
	>=net-libs/webkit-gtk-2.7.2:4
	>=x11-libs/gtk+-3.11.1:3
	x11-libs/pango

	introspection? ( >=dev-libs/gobject-introspection-0.6.2:= )
	kerberos? (
		app-crypt/gcr:0=
		app-crypt/mit-krb5 )
	uoa? (
		dev-libs/libaccounts-glib
		dev-libs/libsignon-glib
		net-im/telepathy-mission-control
		unity-base/gnome-control-center-signon )
"
#	telepathy? ( net-libs/telepathy-glib )
# goa-daemon can launch gnome-control-center
PDEPEND="gnome? ( >=gnome-base/gnome-control-center-3.2[gnome-online-accounts(+)] )"

DEPEND="${RDEPEND}
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.3
	>=dev-util/gdbus-codegen-2.30.0
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig

	dev-libs/gobject-introspection-common
	gnome-base/gnome-common
"
# eautoreconf needs gobject-introspection-common, gnome-common
MAKEOPTS="${MAKEOPTS} -j1"

# Due to sub-configure
QA_CONFIGURE_OPTIONS=".*"

src_prepare() {
	ubuntu-versionator_src_prepare
	# Fix undefined references to libaccounts-glib and libsignon-glib at link time for UOA enabled goabackend #
	if use uoa; then
		sed 's:glib-2.0:glib-2.0 libaccounts-glib libsignon-glib :' \
			-i configure.ac || die
		eautoreconf
	fi
}

src_configure() {
	# TODO: Give users a way to set the G/FB/Windows Live secrets
	# telepathy optional support is really a badly done, bug #494456
	econf \
		--disable-static \
		--enable-backend \
		--disable-twitter \
		--disable-yahoo \
		--enable-documentation \
		--enable-exchange \
		--enable-facebook \
		--enable-flickr \
		--enable-foursquare \
		--enable-google \
		--enable-imap-smtp \
		--enable-lastfm \
		--enable-media-server \
		--enable-owncloud \
		--enable-pocket \
		--enable-telepathy \
		--enable-windows-live \
		$(use_enable kerberos)
		$(use_enable uoa ubuntu-online-accounts)
	# gudev & cheese from sub-configure is overriden
	# by top level configure, and disabled so leave it like that
}

src_install() {
	default

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	#  except telepathy-account-widgets #
	find "${ED}usr/share/locale" \
		-type f \! -name 'gnome-online-accounts-tpaw.mo' \
			-delete 2>/dev/null
	find "${ED}usr/share/locale" -type d -empty -delete 2>/dev/null
}
