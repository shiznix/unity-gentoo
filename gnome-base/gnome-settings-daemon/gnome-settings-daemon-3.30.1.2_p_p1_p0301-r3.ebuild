# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_5,3_6} )

URELEASE="cosmic-updates"
inherit flag-o-matic gnome2 meson python-any-r1 systemd udev virtualx ubuntu-versionator

DESCRIPTION="Gnome Settings Daemon patched for the Unity desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-settings-daemon"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+colord +cups debug elogind input_devices_wacom +networkmanager policykit smartcard systemd test +udev wayland"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="
        ^^ ( elogind systemd )
        input_devices_wacom? ( udev )
        wayland? ( udev )
"
RESTRICT="mirror"

COMMON_DEPEND="
	>=sci-geosciences/geocode-glib-3.10
	>=dev-libs/glib-2.53.0:2[dbus]
	dev-libs/libappindicator:=
	gnome-base/gnome-desktop:3=
	>=gnome-base/gsettings-desktop-schemas-3.27.90
	>=x11-libs/gtk+-3.15.3:3[X,wayland=]
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/libcanberra[gtk3]
	>=media-sound/pulseaudio-2[glib]
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
	colord? (
		>=x11-misc/colord-1.0.2:=
		>=media-libs/lcms-2.2:2 )
	cups? ( >=net-print/cups-1.4[dbus] )
	virtual/libgudev:=
	input_devices_wacom? ( >=dev-libs/libwacom-0.7
		>=x11-libs/pango-1.20.0
		x11-drivers/xf86-input-wacom )
	networkmanager? ( >=net-misc/networkmanager-1.0 )
	smartcard? ( >=dev-libs/nss-3.11.2 )
	udev? ( virtual/libgudev:= )
	wayland? ( dev-libs/wayland )
"
# logind needed for power and session management, bug #464944
# gnome-session-3.27.90 and gdm-3.27.9 adapt to A11yKeyboard component removal (moved to shell dealing with it)
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
	!<gnome-base/gnome-session-3.27.90
	!<gnome-base/gdm-3.27.90
"
# rfkill requires linux/rfkill.h, thus linux-headers dep, not os-headers. If this package wants to work on other kernels, we need to make rfkill conditional instead
DEPEND="${COMMON_DEPEND}
	sys-kernel/linux-headers
	dev-util/glib-utils
	dev-util/gdbus-codegen
	x11-base/xorg-proto
	${PYTHON_DEPS}
	test? (
		$(python_gen_any_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/dbusmock[${PYTHON_USEDEP}]')
		gnome-base/gnome-session )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

python_check_deps() {
	if use test; then
		has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]" &&
		has_version "dev-python/dbusmock[${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare

	# Taken from https://dev.gentoo.org/~leio/distfiles/ patchset #
	eapply "${FILESDIR}/0003-build-Allow-udev-and-NM-optional-on-Linux.patch"
	eapply "${FILESDIR}/0004-build-Make-colord-and-wacom-optional-and-controllabl.patch"

	gnome2_src_prepare
}

src_configure() {
	# Ubuntu 53_sync_input_sources_to_accountsservice.patch adds references to act/act.h but misses telling configure about it #
	append-cflags "$(pkg-config --libs --cflags accountsservice)"

	local emesonargs=(
		#-Dnssdb_dir # TODO: Is the default /etc/pki/nssdb path correct for our nss?
		-Dudev_dir="$(get_udevdir)"
		-Dalsa=true
		$(meson_use udev gudev)
		$(meson_use cups)
		$(meson_use colord)
		$(meson_use networkmanager network_manager)
		-Drfkill=true
		$(meson_use smartcard)
		$(meson_use input_devices_wacom wacom)
		$(meson_use wayland)
		-Dexperimental_suspend_then_hibernate=false
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
