# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="jammy"
inherit autotools gnome2-utils ubuntu-versionator

MY_PN="psensor"

DESCRIPTION="Indicator for monitoring hardware temperature used by the Unity desktop"
HOMEPAGE="http://wpitchoune.net/psensor"
SRC_URI="${UURL}/${MY_PN}_${PV}.orig.tar.gz
	${UURL}/${MY_PN}_${PV}-${UVER}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hddtemp nls"
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	>=dev-libs/json-c-0.12
	dev-libs/libappindicator
	dev-libs/libatasmart
	dev-libs/libayatana-appindicator
	dev-libs/libunity
	gnome-base/gconf
	gnome-base/libgtop
	net-misc/curl
	sys-apps/lm-sensors
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/libX11
	x11-libs/libXext
	hddtemp? ( app-admin/hddtemp )"

S="${WORKDIR}/${MY_PN}-${PV}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	ubuntu-versionator_src_prepare
	eapply "${FILESDIR}/fix-ftbfs.patch"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls)
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

