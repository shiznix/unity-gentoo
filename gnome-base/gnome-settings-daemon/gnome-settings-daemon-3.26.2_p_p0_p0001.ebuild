# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"
GNOME2_LA_PUNT="yes"
#PYTHON_COMPAT=( python{2_7,3_5,3_6,3_6} ) # https://bugzilla.gnome.org/show_bug.cgi?id=783186
PYTHON_COMPAT=( python2_7 )

URELEASE="artful-updates"
inherit flag-o-matic gnome2 python-any-r1 systemd udev virtualx ubuntu-versionator

UURL="mirror://unity/pool/main/g/${PN}"

DESCRIPTION="Gnome Settings Daemon patched for the Unity desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-settings-daemon"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+colord +cups debug input_devices_wacom -openrc-force networkmanager policykit smartcard test +udev wayland"
#KEYWORDS="~amd64 ~x86"
REQUIRED_USE="
	input_devices_wacom? ( udev )
	smartcard? ( udev )
	test? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="mirror !test? ( test )"

COMMON_DEPEND="
	>=dev-libs/glib-2.44.0:2[dbus]
	dev-libs/libappindicator:=
	>=x11-libs/gtk+-3.15.3:3[X]
	>=gnome-base/gnome-desktop-3.11.1:3=
	>=gnome-base/gsettings-desktop-schemas-3.23.3
	>=gnome-base/librsvg-2.36.2:2
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
	>=sys-auth/polkit-0.103

	colord? (
		>=media-libs/lcms-2.2:2
		>=x11-misc/colord-1.0.2:= )
	cups? ( >=net-print/cups-1.4[dbus] )
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7
		>=x11-libs/pango-1.20
		x11-drivers/xf86-input-wacom
		virtual/libgudev:= )
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
	!openrc-force? ( sys-apps/systemd )
	>=x11-themes/gnome-themes-standard-3.22
	!<gnome-base/gnome-control-center-2.22
	!<gnome-extra/gnome-color-manager-3.1.1
	!<gnome-extra/gnome-power-manager-3.1.3
	!<gnome-base/gnome-session-3.23.2
"
# xproto-7.0.15 needed for power plugin
DEPEND="${COMMON_DEPEND}
	cups? ( sys-apps/sed )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/dbusmock[${PYTHON_USEDEP}]')
		gnome-base/gnome-session )
	dev-libs/libxml2:2
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	x11-proto/inputproto
	x11-proto/xf86miscproto
	x11-proto/kbproto
	>=x11-proto/xproto-7.0.15
"

# TypeErrors with python3; weird test errors with python2; all in power component that was made required now
PATCHES=(
	# Make colord and wacom optional; requires eautoreconf
	"${FILESDIR}"/${PV}-optional.patch
	# Allow specifying udevrulesdir via configure, bug 509484; requires eautoreconf
	"${FILESDIR}"/${PV}-udevrulesdir-configure.patch
	# Fix uninstalled (during build) color plugin test run
	"${FILESDIR}"/${PV}-fix-color-tests.patch
	# Reduce memory usage by not initing GTK+ where not needed
	"${FILESDIR}"/${PV}-remove-unneeded-gtk-init.patch
	# Reduce memory usage by using a fake CSS theme instead of full Adwaita for GTK+ needing plugins; requires eautoreconf
	"${FILESDIR}"/${PV}-reduce-memory-usage.patch
)

python_check_deps() {
	if use test; then
		has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]" &&
		has_version "dev-python/dbusmock[${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
	ubuntu-versionator_pkg_setup
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# Ubuntu 53_sync_input_sources_to_accountsservice.patch adds references to act/act.h but misses telling configure about it #
	append-cflags "$(pkg-config --libs --cflags accountsservice)"

	gnome2_src_configure \
		--disable-static \
		--with-udevrulesdir="$(get_udevdir)"/rules.d \
		$(use_enable colord color) \
		$(use_enable cups) \
		$(use_enable debug) \
		$(use_enable debug more-warnings) \
		$(use_enable networkmanager network-manager) \
		$(use_enable smartcard smartcard-support) \
		$(use_enable udev gudev) \
		$(use_enable input_devices_wacom wacom) \
		$(use_enable wayland)
}

src_test() {
	virtx emake check
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! systemd_is_booted; then
		ewarn "${PN} needs Systemd to be *running* for working"
		ewarn "properly. Please follow the this guide to migrate:"
		ewarn "https://wiki.gentoo.org/wiki/Systemd"
	fi

	if use openrc-force; then
		ewarn "You are enabling 'openrc-force' USE flag to skip systemd requirement,"
		ewarn "this can lead to unexpected problems and is not supported neither by"
		ewarn "upstream neither by Gnome Gentoo maintainers. If you suffer any problem,"
		ewarn "you will need to disable this USE flag system wide and retest before"
		ewarn "opening any bug report."
	fi
}
