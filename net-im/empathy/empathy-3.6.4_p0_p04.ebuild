# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.7"
VALA_MIN_API_VERSION="0.20"
VALA_USE_DEPEND="vapigen"

inherit autotools base gnome2 python virtualx ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/e/${PN}"
URELEASE="raring"

DESCRIPTION="Telepathy instant messaging and video/audio call client for GNOME patched for the Unity desktop"
HOMEPAGE="http://live.gnome.org/Empathy"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.bz2"

LICENSE="GPL-2 CC-BY-SA-3.0 FDL-1.3 LGPL-2.1"
SLOT="0"
IUSE="gnome test +v4l"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-linux"
RESTRICT="mirror"

# gdk-pixbuf and pango extensively used in libempathy-gtk
COMMON_DEPEND="
	>=dev-libs/glib-2.33.3:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.5.1:3
	x11-libs/pango
	>=dev-libs/dbus-glib-0.51
	>=dev-libs/folks-0.7.3:=[telepathy]
	dev-libs/libgee:0=
	>=app-crypt/libsecret-0.5
	>=media-libs/libcanberra-0.25[gtk3]
	>=net-libs/gnutls-2.8.5:=
	>=net-libs/webkit-gtk-1.3.13:3
	>=x11-libs/libnotify-0.7

	media-libs/gstreamer:1.0
	>=media-libs/clutter-1.10.0:1.0
	>=media-libs/clutter-gtk-1.1.2:1.0
	media-libs/clutter-gst:2.0
	media-libs/cogl:1.0=

	net-libs/farstream:0.2
	>=net-libs/telepathy-farstream-0.5:=
	>=net-libs/telepathy-glib-0.19.9
	>=net-im/telepathy-logger-0.2.13:=

	app-crypt/gcr
	dev-libs/libxml2:2
	gnome-base/gsettings-desktop-schemas
	media-sound/pulseaudio[glib]
	net-libs/libsoup:2.4
	x11-libs/libX11

	>=net-libs/gnome-online-accounts-3.5.1
	>=gnome-extra/nautilus-sendto-2.90.0
	>=app-text/enchant-1.2
	>=app-text/iso-codes-0.35
	v4l? (
		media-plugins/gst-plugins-v4l2:1.0
		>=media-video/cheese-3.4
		virtual/udev[gudev] )"
# >=empathy-3.4 is incompatible with telepathy-rakia-0.6, bug #403861
RDEPEND="${COMMON_DEPEND}
	dev-libs/libaccounts-glib:=
	dev-libs/libsignon-glib:=
	dev-libs/libunity:=
	media-libs/gst-plugins-base:1.0
	net-im/pidgin[-eds]
	net-im/telepathy-connection-managers
	net-irc/telepathy-idle
	net-libs/account-plugins
	net-voip/telepathy-gabble
	net-voip/telepathy-haze
	net-voip/telepathy-rakia
	>=net-voip/telepathy-salut-0.8.1
	!<net-voip/telepathy-rakia-0.7
	unity-indicators/ido:=
	x11-themes/gnome-icon-theme-symbolic
	gnome? ( gnome-extra/gnome-contacts )"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPENDS}
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=dev-util/intltool-0.50.0
	unity-base/gnome-control-center-signon
	virtual/pkgconfig
	test? (
		sys-apps/grep
		>=dev-libs/check-0.9.4 )
	$(vala_depend)
"
PDEPEND=">=net-im/telepathy-mission-control-5.14"

MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}

src_configure() {
	DOCS="CONTRIBUTORS AUTHORS ChangeLog NEWS README"

	G2CONF="${G2CONF}
		--enable-debug
		--disable-schemas-compile
		--disable-static
		--enable-gst-1.0=yes
		--enable-spell=yes
		--enable-webkit=yes
		--enable-map=no
		--enable-location=no
		--enable-geocode=no
		--enable-gudev=yes
		--enable-call-logs=yes
		--enable-call=yes
		--enable-ubuntu-online-accounts=yes
		--enable-goa=yes
		--enable-libunity=yes
		--enable-nautilus-sendto=yes
		--enable-control-center-embedding=yes
		--with-connectivity=nm
		ITSTOOL=$(type -P true)"
	gnome2_src_configure
}

src_test() {
	Xemake check
}

src_install() {
	gnome2_src_install

	insinto /usr/share/indicators/messages/applications/
	doins "${WORKDIR}/debian/indicators/empathy"
}

pkg_postinst() {
	gnome2_pkg_postinst
	elog "Empathy needs telepathy's connection managers to use any IM protocol."
	elog "See the USE flags on net-im/telepathy-connection-managers"
	elog "to install them."
}
