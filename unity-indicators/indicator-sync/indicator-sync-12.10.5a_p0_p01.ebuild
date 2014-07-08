# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

inherit autotools gnome2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/i/${PN}"
URELEASE="trusty"
UVER_PREFIX="+14.04.20140207"

DESCRIPTION="Indicator for synchronisation processes status used by the Unity desktop"
HOMEPAGE="http://launchpad.net/indicator-sync"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	unity-indicators/ido:="
DEPEND="${RDEPEND}
	>=dev-libs/glib-2.35.4
	dev-libs/libappindicator
	dev-libs/libindicate[gtk,introspection]
	dev-libs/libindicator
	x11-libs/gtk+:3
	x11-libs/pango"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	# Install desktop file #
	sed -e 's:xdg_autostart_DATA = indicator-sync.conf:xdg_autostart_DATA = indicator-sync.desktop:g' \
		-i data/Makefile.am || die

	# Make indicator start using XDG autostart #
	sed -e '/NotShowIn=/d' \
		-i data/indicator-sync.desktop.in

	eautoreconf
	gnome2_src_prepare
}

src_install() {
	emake DESTDIR="${D}" install

	# Remove upstart jobs as we use XDG autostart desktop files to spawn indicators #
	rm -rf "${ED}usr/share/upstart"
}

src_test() {
	emake check
}
