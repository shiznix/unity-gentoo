# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit autotools eutils gnome2-utils ubuntu-versionator

UURL="mirror://unity/pool/main/o/${PN}"
UVER_PREFIX="+16.04.${PVR_MICRO}"

DESCRIPTION="Ayatana Scrollbars use an overlay to ensure scrollbars take up no active screen real-estate"
HOMEPAGE="http://launchpad.net/ayatana-scrollbar"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

# GTK3 support no longer needed, from Changelog: "* Drop overlay-scrollbar-gtk3 - this is no longer needed with GTK 3.16" #
DEPEND="gnome-base/dconf
	x11-libs/gtk+:2"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare

	# Install Xsession file into correct Gentoo path #
	sed -e 's:/X11/Xsession.d:/X11/xinit/xinitrc.d:g' \
		-i data/Makefile*
	eautoreconf
}

src_configure() {
	econf --disable-static \
		--disable-tests
}

src_install() {
	emake DESTDIR="${ED}" install || die
	chmod +x "${ED%/}"/etc/X11/xinit/xinitrc.d/81overlay-scrollbar
	prune_libtool_files --modules
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
