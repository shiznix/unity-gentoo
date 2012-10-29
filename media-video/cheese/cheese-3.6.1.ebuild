# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/cheese/cheese-3.4.2.ebuild,v 1.1 2012/05/24 08:04:54 tetromino Exp $

EAPI="4"
GNOME2_LA_PUNT="yes"

inherit gnome2 virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="A cheesy program to take pictures and videos from your webcam"
HOMEPAGE="http://www.gnome.org/projects/cheese/"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc +introspection sendto test"
KEYWORDS=""

COMMON_DEPEND="
	>=dev-libs/glib-2.28.0:2
	>=dev-libs/libgee-0.6.3:0
	>=x11-libs/gtk+-2.99.4:3[introspection?]
	>=x11-libs/cairo-1.10
	>=x11-libs/pango-1.28.0
	>=sys-fs/udev-171[gudev]
	>=gnome-base/gnome-desktop-2.91.6:3
	>=gnome-base/librsvg-2.32.0:2
	>=media-libs/libcanberra-0.26[gtk3]
	>=media-libs/clutter-1.10.0:1.0[introspection?]
	>=media-libs/clutter-gtk-0.91.8:1.0
	media-libs/clutter-gst:2.0

	media-video/gnome-video-effects
	x11-libs/gdk-pixbuf:2[jpeg,introspection?]
	x11-libs/mx
	x11-libs/libX11
	x11-libs/libXtst

	media-libs/gstreamer:1.0[introspection?]
	media-libs/gst-plugins-base:1.0[introspection?]

	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"
RDEPEND="${COMMON_DEPEND}
	media-libs/gst-plugins-bad:1.0
	media-libs/gst-plugins-good:1.0
	media-plugins/gst-plugins-ogg:1.0
	media-plugins/gst-plugins-pango:1.0
	media-plugins/gst-plugins-theora:1.0
	media-plugins/gst-plugins-vorbis:1.0
	media-plugins/gst-plugins-jpeg:1.0
	media-plugins/gst-plugins-v4l2:1.0
	media-plugins/gst-plugins-vpx:1.0

	|| ( media-plugins/gst-plugins-x:1.0
		media-plugins/gst-plugins-xvideo:1.0 )

	sendto? ( >=gnome-extra/nautilus-sendto-2.91 )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40

	app-text/docbook-xml-dtd:4.3
	dev-libs/libxml2:2
	dev-util/itstool
	x11-proto/xf86vidmodeproto

	doc? ( >=dev-util/gtk-doc-1.14 )
	test? ( dev-libs/glib:2[utils] )"

if [[ ${PV} = 9999 ]]; then
	DEPEND+=" dev-lang/vala:0.18"
fi

pkg_setup() {
	G2CONF="${G2CONF}
		VALAC=$(type -p valac-0.18)
		$(use_enable introspection)
		--disable-lcov
		--disable-static"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_configure() {
	# Work around sandbox violations when FEATURES=-userpriv (bug #410061)
	unset DISPLAY
	gnome2_src_configure
}

src_compile() {
	# Clutter-related sandbox violations when USE="doc introspection" and
	# FEATURES="-userpriv" (see bug #385917).
	unset DISPLAY
	gnome2_src_compile
}

src_test() {
	Xemake check
}
