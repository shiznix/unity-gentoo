# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

inherit autotools eutils flag-o-matic gnome2 ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/i/${PN}"
URELEASE="utopic"
UVER_PREFIX="+14.10.20140814.1"

DESCRIPTION="Indicator that collects messages that need a response used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-messages"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="!net-im/indicator-messages
	dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate-qt
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eautoreconf
	append-cflags -Wno-error

	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	gnome2_src_prepare
}

src_install() {
	emake DESTDIR="${ED}" install

	# Remove upstart jobs as we use /etc/xdg/autostart/*.desktop files #
	rm -rf "${ED}usr/share/upstart"
}
