# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

URELEASE="xenial-updates"
inherit autotools base eutils gnome2 ubuntu-versionator

UURL="mirror://unity/pool/universe/g/${PN}"

DESCRIPTION="The GNOME panel patched for the Unity desktop"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="0"
IUSE="eds +introspection networkmanager"
# Odd behaviour w.r.t. panels: https://bugzilla.gnome.org/show_bug.cgi?id=631553
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="!<gnome-base/gnome-session-3.8
	>=dev-libs/glib-2.46.0:2
	>=dev-libs/libgweather-3.18:2=
	dev-libs/libxml2:2
	gnome-base/dconf
	gnome-base/gconf:2[introspection?]
	>=gnome-base/gnome-desktop-3.18:3=
	>=gnome-base/gnome-menus-3.13:3
	gnome-base/gsettings-desktop-schemas
	gnome-base/librsvg:2
	net-libs/telepathy-glib
	sys-auth/polkit
	x11-libs/cairo[X]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.18:3[introspection?]
	x11-libs/libXau
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXrandr
	x11-libs/libwnck:3
	>=x11-libs/pango-1.38[introspection?]

	eds? ( >=gnome-extra/evolution-data-server-3.18:= )
	introspection? ( >=dev-libs/gobject-introspection-1.46 )
	networkmanager? ( >=net-misc/networkmanager-1.0.10 )"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=dev-lang/perl-5
	dev-util/gtk-doc-am
	dev-util/intltool
	virtual/pkgconfig"
# eautoreconf needs
#	dev-libs/gobject-introspection-common
#	gnome-base/gnome-common

src_prepare() {
	sed -i '/ubuntu_language.patch/d' "${WORKDIR}/debian/patches/series" || die
	ubuntu-versionator_src_prepare
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	# XXX: Make presence/telepathy-glib support optional?
	#      We can do that if we intend to support fallback-only as a setup
	gnome2_src_configure \
		--disable-deprecation-flags \
		--disable-static \
		--with-in-process-applets=clock,notification-area,wncklet \
		--enable-telepathy-glib \
		$(use_enable networkmanager network-manager) \
		$(use_enable introspection) \
		$(use_enable eds) \
		ITSTOOL=$(type -P true)
}
