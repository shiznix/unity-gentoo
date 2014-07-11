# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

inherit gnome2 ubuntu-versionator

MY_PN="psensor"
UURL="mirror://ubuntu/pool/universe/p/${MY_PN}"
URELEASE="utopic"

DESCRIPTION="Indicator for monitoring hardware temperature used by the Unity desktop"
HOMEPAGE="http://wpitchoune.net/psensor"
SRC_URI="${UURL}/${MY_PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="hddtemp nls"
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	<dev-libs/json-c-0.12
	dev-libs/libappindicator
	dev-libs/libatasmart
	dev-libs/libunity
	gnome-base/gconf
	gnome-base/libgtop
	net-misc/curl
	sys-apps/lm_sensors
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/libX11
	x11-libs/libXext
	hddtemp? ( app-admin/hddtemp )"

S="${WORKDIR}/${MY_PN}-${PV}"
	

src_configure() {
	econf \
		$(use_enable nls)
}
