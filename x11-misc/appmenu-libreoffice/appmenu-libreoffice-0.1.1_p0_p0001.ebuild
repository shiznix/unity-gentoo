# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit ubuntu-versionator

MY_PN="lo-menubar"
MY_P="${MY_PN}_${PV}"

UURL="mirror://ubuntu/pool/universe/l/${MY_PN}"
URELEASE="quantal"

DESCRIPTION="Unity appmenu integration for Libreoffice office suite"
HOMEPAGE="https://launchpad.net/lo-menubar"
SRC_URI="( x86? ( ${UURL}/${MY_P}-${UVER}_i386.deb )
		amd64? ( ${UURL}/${MY_P}-${UVER}_amd64.deb ) )"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="|| ( app-office/libreoffice app-office/libreoffice-bin )
		app-text/gnome-doc-utils
		dev-libs/libdbusmenu
		x11-misc/appmenu-gtk"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PRESTRIPPED="/usr/lib/libreoffice/share/extensions/menubar/Linux_x86_64/menubar.uno.so"

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
}

src_install() {
	cp -R usr "${D}"
}
