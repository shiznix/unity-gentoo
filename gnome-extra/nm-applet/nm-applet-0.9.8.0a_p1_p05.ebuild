# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools base eutils gnome2 ubuntu-versionator

MY_PN="network-manager-applet"
MY_P="${MY_PN}_${PV}"
S="${WORKDIR}/${MY_PN}-${PV}"

UURL="mirror://ubuntu/pool/main/n/${MY_PN}"
URELEASE="trusty"
MY_P="${MY_P/applet-/applet_}"

DESCRIPTION="GNOME applet for NetworkManager patched for the Unity desktop"
HOMEPAGE="http://projects.gnome.org/NetworkManager/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="bluetooth gconf modemmanager systemd"
#KEYWORDS="~amd64 ~ppc ~x86"
RESTRICT="mirror"

RDEPEND=">=dev-libs/glib-2.26:2
	>=dev-libs/dbus-glib-0.88
	dev-libs/libappindicator:=
	>=gnome-base/gnome-keyring-2.20
	>=sys-apps/dbus-1.6.12[systemd?]
	>=sys-auth/polkit-0.96-r1
	>=x11-libs/gtk+-2.91.4:3
	>=x11-libs/libnotify-0.7.0

	app-text/iso-codes
	>=net-misc/networkmanager-0.9.8
	net-misc/mobile-broadband-provider-info

	bluetooth? ( >=net-wireless/gnome-bluetooth-2.27.6 )
	gconf? ( >=gnome-base/gconf-2.20:2 )
	virtual/freedesktop-icon-theme"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40"

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	PATCHES+=( "${FILESDIR}/modemmanager_build-fix.diff" )
	base_src_prepare

	eautoreconf

	sed -e "s:-Werror::g" \
		-i "configure" || die
}

src_configure() {
	gnome2_src_configure \
		--enable-indicator \
		--with-gtkver=3 \
		--disable-more-warnings \
		--disable-static \
		--localstatedir=/var \
		$(use_with bluetooth) \
		$(use_enable gconf migration) \
		$(use_with modemmanager modem-manager-1)
}

src_install() {
	gnome2_src_install

	insinto /usr/share/icons/hicolor/22x22/apps
	doins "${WORKDIR}"/debian/icons/22/*.png
	dosym nm-signal-00.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-none.png
	dosym nm-signal-00-secure.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-none-secure.png
	dosym nm-signal-25.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-low.png
	dosym nm-signal-25-secure.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-low-secure.png
	dosym nm-signal-50.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-medium.png
	dosym nm-signal-50-secure.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-medium-secure.png
	dosym nm-signal-75.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-high.png
	dosym nm-signal-75-secure.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-high-secure.png
	dosym nm-signal-100.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-full.png
	dosym nm-signal-100-secure.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-full-secure.png
}
