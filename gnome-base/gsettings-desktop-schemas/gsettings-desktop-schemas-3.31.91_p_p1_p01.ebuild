# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="disco"
inherit autotools gnome2 ubuntu-versionator

DESCRIPTION="Collection of GSettings schemas for GNOME desktop"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+introspection unico"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="dev-libs/glib:2
	unity-base/unity-settings
	x11-themes/ubuntu-themes
	x11-themes/ubuntu-wallpapers

	introspection? ( dev-libs/gobject-introspection )
	unico? ( x11-themes/gtk-engines-unico )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS HACKING NEWS README"
	gnome2_src_configure $(use_enable introspection)
}
