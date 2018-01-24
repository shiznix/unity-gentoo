# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
VALA_USE_DEPEND="vapigen"

URELEASE="zesty"
inherit autotools gnome2 ubuntu-versionator vala

UURL="mirror://unity/pool/main/g/${PN}"

DESCRIPTION="GNOME framework for accessing online accounts"
HOMEPAGE="https://wiki.gnome.org/GnomeOnlineAccounts"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"
LICENSE="LGPL-2+"
SLOT="0/1"
IUSE="debug gnome +introspection kerberos uoa vala"
REQUIRED_USE="vala? ( introspection )"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

# pango used in goaeditablelabel
# libsoup used in goaoauthprovider
# goa kerberos provider is incompatible with app-crypt/heimdal, see
# https://bugzilla.gnome.org/show_bug.cgi?id=692250
# json-glib-0.16 needed for bug #485092
RDEPEND="
	>=dev-libs/glib-2.44:2
	>=app-crypt/libsecret-0.5
	>=dev-libs/json-glib-0.16
	dev-libs/libxml2:2
	>=net-libs/libsoup-2.42:2.4
	net-libs/rest:0.7
	net-libs/telepathy-glib
	>=net-libs/webkit-gtk-2.7.2:4
	>=x11-libs/gtk+-3.19.12:3
	x11-libs/pango

	introspection? ( >=dev-libs/gobject-introspection-0.6.2:= )
	kerberos? (
		app-crypt/gcr:0=[gtk]
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
	vala? ( $(vala_depend) )
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

# Due to sub-configure
QA_CONFIGURE_OPTIONS=".*"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	ubuntu-versionator_src_prepare

	# Fix undefined references to libaccounts-glib and libsignon-glib at link time for UOA enabled goabackend #
	if use uoa; then
		sed 's:glib-2.0:glib-2.0 libaccounts-glib libsignon-glib :' \
			-i configure.ac || die
		eautoreconf
	fi

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# TODO: Give users a way to set the G/FB/Windows Live secrets
	# telepathy optional support is really a badly one, bug #494456
	gnome2_src_configure \
		--disable-static \
		--enable-backend \
		--enable-documentation \
		--enable-exchange \
		--enable-facebook \
		--enable-flickr \
		--enable-foursquare \
		--enable-imap-smtp \
		--enable-lastfm \
		--enable-media-server \
		--enable-owncloud \
		--enable-pocket \
		--enable-telepathy \
		--enable-windows-live \
		$(use_enable uoa ubuntu-online-accounts)
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable kerberos) \
		$(use_enable introspection) \
		$(use_enable vala)
		#$(use_enable telepathy)
	# gudev & cheese from sub-configure is overriden
	# by top level configure, and disabled so leave it like that
}
