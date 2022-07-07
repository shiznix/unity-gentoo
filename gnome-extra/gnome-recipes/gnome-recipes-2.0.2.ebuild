# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils gnome.org meson xdg

DESCRIPTION="Cooking recipe application"
HOMEPAGE="https://wiki.gnome.org/Apps/Recipes"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="archive libcanberra spell"

RDEPEND="
	dev-libs/appstream-glib
	dev-libs/glib:2
	>=dev-libs/gobject-introspection-1.42.0
	dev-libs/json-glib
	dev-util/itstool
	net-libs/gnome-online-accounts
	net-libs/libsoup:2.4
	net-libs/rest:0.7
	>=x11-libs/gtk+-3.22:3
	archive? ( app-arch/gnome-autoar )
	libcanberra? ( media-libs/libcanberra )
	spell? ( app-text/gspell )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	# Fix launcher icon and global/titlebar menu app name
	sed -i \
		-e "/DBusActivatable/d" \
		data/org.gnome.Recipes.desktop.in

	# If a .desktop file does not have inline
	# translations, fall back to calling gettext
	echo "X-GNOME-Gettext-Domain=${PN}" >> "data/org.gnome.Recipes.desktop.in"

	default
}

src_configure() {
	local emesonargs=(
		-Dautoar=$(usex archive yes no)
		-Dcanberra=$(usex libcanberra yes no)
		-Dgspell=$(usex spell yes no)
	)

	meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
	xdg_pkg_postrm
}
