# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

URELEASE="cosmic"
inherit autotools eutils gnome2 ubuntu-versionator

UVER="-${PVR_MICRO}"

DESCRIPTION="A widget toolkit using Clutter"
HOMEPAGE="http://clutter-project.org/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}${UVER}.debian.tar.xz"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="+introspection startup-notification"
RESTRICT="mirror"

RDEPEND="
	>=dev-libs/glib-2.31.0:2
	>=media-libs/clutter-1.7.91:1.0
	media-libs/cogl:=
	>=x11-apps/xrandr-1.2.0
	x11-libs/gdk-pixbuf:2[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
	startup-notification? ( >=x11-libs/startup-notification-0.9 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--with-winsys=x11 \
		--without-glade \
		$(use_enable introspection) \
		$(use_with startup-notification)
}
