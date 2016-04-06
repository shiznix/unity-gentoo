# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"

URELEASE="xenial"
inherit base gnome2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/g/${PN}"

DESCRIPTION="Collection of GSettings schemas for GNOME desktop"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+introspection"
#KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="dev-libs/glib:2
	introspection? ( dev-libs/gobject-introspection )
	x11-themes/gnome-backgrounds
	x11-themes/gtk-engines-unico
	x11-themes/ubuntu-themes
	x11-themes/ubuntu-wallpapers"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	ubuntu-versionator_src_prepare
	gnome2_src_prepare

	# Set Ambiance as the default window theme #
	sed -e '/gtk-theme/{n;s/Adwaita/Ambiance/}' \
		-i schemas/org.gnome.desktop.wm.preferences.gschema.xml.in  \
			schemas/org.gnome.desktop.interface.gschema.xml.in

	# Set Ubuntu-mono-dark as the default icon theme #
	sed -e '/icon-theme/{n;s/Adwaita/ubuntu-mono-dark/}' \
		-i schemas/org.gnome.desktop.interface.gschema.xml.in

	# Set default Ubuntu release backgrounds #
	sed -e "s:backgrounds/gnome/adwaita-timed.xml:backgrounds/contest/${URELEASE}.xml:" \
		-i schemas/org.gnome.desktop.background.gschema.xml.in

	# Ensure nautilus shows desktop icons by default #
	sed -e '/show-desktop-icons/{n;s/false/true/}' \
		-i schemas/org.gnome.desktop.background.gschema.xml.in
}

src_configure() {
	DOCS="AUTHORS HACKING NEWS README"
	gnome2_src_configure $(use_enable introspection)
}
