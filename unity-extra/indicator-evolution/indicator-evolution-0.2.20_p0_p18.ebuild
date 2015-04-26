# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

URELEASE="vivid"
inherit autotools base gnome2 ubuntu-versionator

MY_PN="evolution-indicator"
UURL="mirror://ubuntu/pool/main/e/${MY_PN}"

DESCRIPTION="Indicator for the Evolution mail client used by the Unity desktop"
HOMEPAGE="https://launchpad.net/evolution-indicator"
SRC_URI="${UURL}/${MY_PN}_${PV}.orig.tar.gz
	${UURL}/${MY_PN}_${PV}-${UVER}.debian.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/dee:=
	dev-libs/glib:2
	dev-libs/libdbusmenu:=
	dev-libs/libunity:=
	dev-libs/libappindicator
	dev-libs/libindicate[gtk,introspection]
	gnome-base/gconf
	gnome-extra/evolution-data-server
	mail-client/evolution
	media-libs/libcanberra
	unity-indicators/indicator-messages
	x11-libs/libnotify"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
	eautoreconf
}

src_configure() {
	econf --disable-static
}
