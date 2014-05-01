# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"

inherit autotools base gnome2 ubuntu-versionator

UURL="https://github.com/shiznix/unity-gentoo/raw/master/files"
URELEASE="trusty"
MY_P="${PN}3_${PV}"

DESCRIPTION="Libraries for the gnome desktop that are not part of the UI patched for the Unity desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-desktop"
SRC_URI="http://ftp.gnome.org/pub/gnome/sources/${PN}/3.10/${PN}-${PV}.tar.xz
	${UURL}/${MY_P}-${UVER}~saucy1.debian.tar.gz"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="3/8" # subslot = libgnome-desktop-3 soname version
IUSE="+introspection"
#KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~x86-solaris"
RESTRICT="mirror"

# cairo[X] needed for gnome-bg
COMMON_DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.35:2
	>=x11-libs/gdk-pixbuf-2.21.3:2[introspection?]
	>=x11-libs/gtk+-3.3.6:3[introspection?]
	>=x11-libs/libXext-1.1
	>=x11-libs/libXrandr-1.3
	x11-libs/cairo:=[X]
	x11-libs/libxkbfile
	x11-libs/libX11
	x11-misc/xkeyboard-config
	>=gnome-base/gsettings-desktop-schemas-3.5.91
	introspection? ( >=dev-libs/gobject-introspection-0.9.7 )
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-desktop-2.32.1-r1:2[doc]
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/gtk-doc-am-1.4
	>=dev-util/intltool-0.40.6
	sys-devel/gettext
	x11-proto/xproto
	>=x11-proto/randrproto-1.2
	virtual/pkgconfig
	gnome-extra/yelp
"

# Includes X11/Xatom.h in libgnome-desktop/gnome-bg.c which comes from xproto
# Includes X11/extensions/Xrandr.h that includes randr.h from randrproto (and
# eventually libXrandr shouldn't RDEPEND on randrproto)

src_prepare() {
	sed -i '/ubuntu_language.patch/d' "${WORKDIR}/debian/patches/series" || die
	sed -i '/ubuntu_language_list_from_SUPPORTED.patch/d' "${WORKDIR}/debian/patches/series" || die
        for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
                PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
        done
	base_src_prepare

        eautoreconf
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	# Note: do *not* use "--with-pnp-ids-path" argument. Otherwise, the pnp.ids
	# file (needed by other packages such as >=gnome-settings-daemon-3.1.2)
	# will not get installed in ${pnpdatadir} (/usr/share/libgnome-desktop-3.0).
	gnome2_src_configure \
		--disable-static \
		--with-gnome-distributor=Gentoo \
		--enable-desktop-docs \
		$(use_enable introspection) \
		ITSTOOL=$(type -P true)
}
