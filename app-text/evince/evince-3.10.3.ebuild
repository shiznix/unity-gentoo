# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/evince/Attic/evince-3.10.3.ebuild,v 1.6 2014/09/02 10:31:45 pacho dead $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="http://www.gnome.org/projects/evince/"

LICENSE="GPL-2+ CC-BY-SA-3.0"
# subslot = evd3.(suffix of libevdocument3)-evv3.(suffix of libevview3)
SLOT="0/evd3.4-evv3.3"
IUSE="debug djvu dvi +introspection libsecret nautilus +postscript t1lib tiff xps"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris"

# Since 2.26.2, can handle poppler without cairo support. Make it optional ?
# not mature enough
# atk used in libview
# gdk-pixbuf used all over the place
# libX11 used for totem-screensaver
COMMON_DEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.36:2
	>=dev-libs/libxml2-2.5:2
	sys-libs/zlib:=
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.8:3[introspection?]
	x11-libs/libX11:=
	>=x11-libs/libSM-1:=
	x11-libs/libICE:=
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/cairo-1.10:=
	>=app-text/poppler-0.24:=[cairo]
	djvu? ( >=app-text/djvu-3.5.17:= )
	dvi? (
		virtual/tex-base
		dev-libs/kpathsea:=
		t1lib? ( >=media-libs/t1lib-5:= ) )
	introspection? ( >=dev-libs/gobject-introspection-1 )
	libsecret? ( >=app-crypt/libsecret-0.5 )
	nautilus? ( >=gnome-base/nautilus-2.91.4[introspection?] )
	postscript? ( >=app-text/libspectre-0.2.0:= )
	tiff? ( >=media-libs/tiff-3.6:0= )
	xps? ( >=app-text/libgxps-0.2.1:= )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/librsvg
	|| (
		>=x11-themes/gnome-icon-theme-2.17.1
		>=x11-themes/hicolor-icon-theme-0.10 )
	x11-themes/gnome-icon-theme-symbolic
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.3
	dev-util/gdbus-codegen
	sys-devel/gettext
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	virtual/pkgconfig"

# Needs dogtail and pyspi from http://fedorahosted.org/dogtail/
# Releases: http://people.redhat.com/zcerza/dogtail/releases/
RESTRICT="test"

src_prepare() {
	# ???
	ELTCONF="--portage"

	gnome2_src_prepare

	# Do not depend on gnome-icon-theme, bug #326855, #391859
	sed -e 's/gnome-icon-theme >= $GNOME_ICON_THEME_REQUIRED//g' \
		-i configure || die "sed failed"
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--disable-tests \
		--enable-pdf \
		--enable-comics \
		--enable-thumbnailer \
		--with-smclient=xsmp \
		--with-platform=gnome \
		--enable-dbus \
		$(use_enable djvu) \
		$(use_enable dvi) \
		$(use_with libsecret keyring) \
		$(use_enable introspection) \
		$(use_enable nautilus) \
		$(use_enable postscript ps) \
		$(use_enable t1lib) \
		$(use_enable tiff) \
		$(use_enable xps) \
		ITSTOOL=$(type -P true)
}
