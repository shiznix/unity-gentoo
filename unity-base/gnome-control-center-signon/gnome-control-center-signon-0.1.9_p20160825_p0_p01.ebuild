# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit autotools eutils gnome2-utils ubuntu-versionator vala

UURL="mirror://unity/pool/main/g/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Online account plugin for unity-control-center used by the Unity desktop"
HOMEPAGE="https://launchpad.net/online-accounts-gnome-control-center"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
#KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="net-im/pidgin[-eds,dbus,gadu,groupwise,idn,meanwhile,networkmanager,sasl,silc,zephyr]
	net-im/telepathy-logger
	net-irc/telepathy-idle
	net-voip/telepathy-gabble
	net-voip/telepathy-haze
	net-voip/telepathy-rakia
	net-voip/telepathy-salut
	unity-base/signon-ui"
DEPEND="dev-libs/libaccounts-glib:=
	dev-libs/libsignon-glib:=
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-libs/gtk+:3
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	ubuntu-versionator_src_prepare

	# If a .desktop file does not have inline translations, fall back #
	#  to calling gettext #
	find ${WORKDIR} -type f -name "*.desktop*" \
		-exec sh -c 'sed -i -e "/\[Desktop Entry\]/a X-GNOME-Gettext-Domain=credentials-control-center" "$1"' -- {} \;

	vala_src_prepare
	eautoreconf
}

src_configure() {
	econf --disable-coverage
}

pkg_postinst() {
	elog "To reset all Online Accounts do the following as your desktop user:"
	elog "rm -rfv ~/.cache/telepathy ~/.local/share/telepathy ~/.config/libaccounts-glib"
}
