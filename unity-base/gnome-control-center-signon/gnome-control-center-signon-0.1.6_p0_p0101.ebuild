# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION=0.16

inherit autotools eutils gnome2 ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/g/${PN}"
URELEASE="raring-updates"
UVER_PREFIX="bzr13.04.05"

DESCRIPTION="Online account plugin for gnome-control-center used by the Unity desktop"
HOMEPAGE="https://launchpad.net/online-accounts-gnome-control-center"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="dev-libs/libaccounts-glib:=
	dev-libs/libsignon-glib:=
	net-im/pidgin[-eds,dbus,gadu,groupwise,idn,meanwhile,networkmanager,sasl,silc,zephyr]
	net-im/telepathy-logger
	net-irc/telepathy-idle
	net-voip/telepathy-gabble
	net-voip/telepathy-haze
	net-voip/telepathy-rakia
	>=net-voip/telepathy-salut-0.8.1
	unity-base/signon-ui"
DEPEND="dev-libs/libaccounts-glib
	dev-libs/libsignon-glib
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=dev-util/intltool-0.40.1
	gnome-base/gnome-control-center
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	x11-libs/gtk+:3
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"
	vala_src_prepare
	eautoreconf
}

pkg_postinst() {
	elog
	elog "To reset all Online Accounts do the following as your desktop user:"
	elog "rm -rfv ~/.cache/telepathy ~/.local/share/telepathy ~/.config/libaccounts-glib"
	elog
}
