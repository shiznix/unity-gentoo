# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="saucy"
UVER_PREFIX="+13.10.20130628"

DESCRIPTION="GTK+ module for exporting old-style menus as GMenuModels"
HOMEPAGE="https://launchpad.net/unity-gtk-module"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=[gtk]"
DEPEND="${RDEPEND}
	x11-libs/libX11
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	!x11-misc/appmenu-gtk"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die

	rm -rf "${D}etc" &> /dev/null
	exeinto /etc/X11/xinit/xinitrc.d/
	doexe data/80unity-gtk-module

	prune_libtool_files --modules
} 
