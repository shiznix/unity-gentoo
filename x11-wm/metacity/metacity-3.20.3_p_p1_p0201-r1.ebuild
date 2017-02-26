# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety-updates"
inherit eutils gnome2-utils ubuntu-versionator

UURL="mirror://unity/pool/main/m/${PN}"

DESCRIPTION="GNOME default window manager"
HOMEPAGE="http://blogs.gnome.org/metacity/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test xinerama"
RESTRICT="mirror"

# XXX: libgtop is automagic, hard-enabled instead
RDEPEND="x11-libs/gtk+:3
	x11-libs/pango[X]
	dev-libs/glib:2
	gnome-base/gsettings-desktop-schemas
	x11-libs/startup-notification
	x11-libs/libXcomposite
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXdamage
	x11-libs/libXcursor
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libSM
	x11-libs/libICE
	media-libs/libcanberra[gtk]
	gnome-base/libgtop
	gnome-extra/zenity
	xinerama? ( x11-libs/libXinerama )
	!x11-misc/expocity"
DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.8
	gnome-base/gconf
	sys-devel/gettext
	dev-util/itstool
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	test? ( app-text/docbook-xml-dtd:4.5 )
	xinerama? ( x11-proto/xineramaproto )
	x11-proto/xextproto
	x11-proto/xproto"

src_prepare() {
	ubuntu-versionator_src_prepare
}

src_configure() {
	econf ${myconf} \
		--disable-static \
		--enable-canberra \
		--enable-compositor \
		--enable-render \
		--enable-sm \
		--enable-startup-notification \
		$(use_enable xinerama)
}

src_install() {
	emake DESTDIR="${ED}" install
	dodoc AUTHORS ChangeLog HACKING NEWS README *.txt doc/*.txt
	prune_libtool_files --modules

	insinto /usr/share/glib-2.0/schemas
	newins "${WORKDIR}"/debian/metacity-common.gsettings-override \
		10_metacity-common.gschema.override
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
}
