# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"

URELEASE="xenial"
inherit autotools eutils gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
UVER_PREFIX="+15.04.${PVR_MICRO}"

DESCRIPTION="Indicator showing active print jobs used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-printers"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="app-admin/system-config-printer
	dev-libs/glib:2
	dev-libs/libappindicator
	dev-libs/libdbusmenu[gtk3]
	dev-libs/libindicator:3
	net-print/cups
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"        # This needs to be applied for the debian/ directory to be present #

	sed -e 's/SESSION=ubuntu/SESSION=unity/g' \
		-i data/indicator-printers.conf.in

	eautoreconf
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	cd debian/local
		for file in $(find . -name printer-symbolic.svg); do
			insinto /usr/share/icons/$(dirname "${file}")
			doins "${file}"
		done
}
