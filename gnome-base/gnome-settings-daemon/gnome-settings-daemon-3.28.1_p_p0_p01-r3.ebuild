# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_5,3_6} )

URELEASE="bionic"
inherit flag-o-matic gnome2 meson python-any-r1 systemd udev virtualx ubuntu-versionator

DESCRIPTION="Gnome Settings Daemon patched for the Unity desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-settings-daemon"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+cups debug input_devices_wacom +networkmanager policykit -smartcard test +udev wayland"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="udev"
RESTRICT="mirror"

COMMON_DEPEND="
	>=dev-libs/glib-2.44.0:2[dbus]
	dev-libs/libappindicator:=
	>=x11-libs/gtk+-3.15.3:3[wayland=,X]
	gnome-base/gnome-desktop:3=
	>=gnome-base/gsettings-desktop-schemas-3.23.3
	gnome-base/librsvg:2
	media-fonts/cantarell
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/libcanberra[gtk3]
	>=media-sound/pulseaudio-2
	sys-apps/accountsservice
	>=sys-power/upower-0.99:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/libnotify-0.7.3:=
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXtst
	x11-libs/libXxf86misc
	x11-misc/xkeyboard-config

	>=app-misc/geoclue-2.3.1:2.0
	>=dev-libs/libgweather-3.9.5:2=
	>=sci-geosciences/geocode-glib-3.10
	>=sys-auth/polkit-0.114

	>=media-libs/lcms-2.2:2
	>=x11-misc/colord-1.0.2:=
	cups? ( >=net-print/cups-1.4[dbus] )
	>=x11-libs/pango-1.20
	virtual/libgudev:=
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7
		x11-drivers/xf86-input-wacom )
	networkmanager? ( >=net-misc/networkmanager-1.0 )
	smartcard? ( >=dev-libs/nss-3.11.2 )
	udev? ( virtual/libgudev:= )
	wayland? ( dev-libs/wayland )
"

# Themes needed by g-s-d, gnome-shell, gtk+:3 apps to work properly
# <gnome-color-manager-3.1.1 has file collisions with g-s-d-3.1.x
# <gnome-power-manager-3.1.3 has file collisions with g-s-d-3.1.x
# systemd needed for power and session management, bug #464944
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	!<gnome-base/gnome-control-center-2.22
	!<gnome-extra/gnome-color-manager-3.1.1
	!<gnome-extra/gnome-power-manager-3.1.3
	!<gnome-base/gnome-session-3.27.90
"

# xproto-7.0.15 needed for power plugin
# FIXME: tests require dbus-mock
DEPEND="${COMMON_DEPEND}
	cups? ( sys-apps/sed )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
		gnome-base/gnome-session )
	app-text/docbook-xsl-stylesheets
	dev-libs/libxml2:2
	dev-libs/libxslt
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	x11-proto/inputproto
	x11-proto/xf86miscproto
	>=x11-proto/xproto-7.0.15
"

src_prepare() {
	ubuntu-versionator_src_prepare
	eapply "${FILESDIR}/${P/_*}-optional-wacom-wayland.patch"
	gnome2_src_prepare
}

src_configure() {
	# Ubuntu 53_sync_input_sources_to_accountsservice.patch adds references to act/act.h but misses telling configure about it #
	append-cflags "$(pkg-config --libs --cflags accountsservice)"

	local emesonargs=(
		$(meson_use udev gudev)
		$(meson_use cups)
		$(meson_use networkmanager network_manager)
		$(meson_use smartcard)
		$(meson_use input_devices_wacom wacom)
		$(meson_use wayland)
	)
	meson_src_configure
}
