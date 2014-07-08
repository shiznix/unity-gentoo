# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

inherit base gnome2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/g/${PN}"
URELEASE="trusty"

DESCRIPTION="Collection of GSettings schemas for GNOME desktop"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
        ${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+introspection"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~sparc-solaris ~x86-solaris"

RDEPEND="
	>=dev-libs/glib-2.31:2
	introspection? ( >=dev-libs/gobject-introspection-1.31.0 )
	>=x11-themes/gnome-backgrounds-3.8.1
	x11-themes/gtk-engines-unico
	x11-themes/ubuntu-themes
	x11-themes/ubuntu-wallpapers
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	PATCHES+=( "${FILESDIR}/nautilus_show_desktop_icons.diff" )

        base_src_prepare
	gnome2_src_prepare

	# Set Ambiance as the default window theme #
	sed -e 's:Adwaita:Ambiance:' \
		-i schemas/org.gnome.desktop.wm.preferences.gschema.xml.in.in \
			schemas/org.gnome.desktop.interface.gschema.xml.in.in
	# Set Ubuntu-mono-dark as the default icon theme #
	sed -e "s:'gnome':'ubuntu-mono-dark':" \
		-i schemas/org.gnome.desktop.interface.gschema.xml.in.in

	# Set default Ubuntu release backgrounds #
	sed -e "s:themes/Adwaita/backgrounds/adwaita-timed.xml:backgrounds/contest/trusty.xml:" \
		-i schemas/org.gnome.desktop.background.gschema.xml.in.in

	# Set window controls buttons on the left side of the titlebar by default as in native Unity #
	sed -s "s:\:minimize,maximize,close:close,minimize,maximize\::" \
		-i schemas/org.gnome.desktop.wm.preferences.gschema.xml.in.in
}

src_configure() {
	DOCS="AUTHORS HACKING NEWS README"
	gnome2_src_configure $(use_enable introspection)
}
