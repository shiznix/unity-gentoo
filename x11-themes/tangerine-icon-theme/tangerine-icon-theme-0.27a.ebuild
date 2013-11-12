# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit gnome2-utils ubuntu-versionator

URELEASE="trusty"
UVER=

DESCRIPTION="A derivative of the standard Tango theme, using a more orange approach"
HOMEPAGE="http://packages.ubuntu.com/gutsy/x11/tangerine-icon-theme"
SRC_URI="mirror://ubuntu/pool/universe/t/${PN}/${MY_P}.tar.gz"

LICENSE="CC-BY-SA-2.5"
SLOT="0"
#KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

RESTRICT="binchecks strip mirror"

DEPEND="dev-util/intltool
	sys-devel/gettext
	x11-misc/icon-naming-utils"

src_unpack() {
	unpack ${PN}_${PV}.tar.gz
}

src_prepare() {
	sed -e 's:lib/icon-naming-utils/icon:libexec/icon:' \
		-i Makefile || die
}

src_compile() {
	emake index.theme
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
