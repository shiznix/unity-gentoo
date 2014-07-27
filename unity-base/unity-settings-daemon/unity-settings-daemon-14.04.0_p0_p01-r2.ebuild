# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

inherit autotools base bzr eutils flag-o-matic gnome2 virtualx ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="trusty-updates"
UVER_PREFIX="+14.04.20140606"

DESCRIPTION="Unity Settings Daemon"
HOMEPAGE="https://launchpad.net/unity-settings-daemon"
SRC_URI=	# 'gnome2' inherits 'gnome.org' which tries to set SRC_URI

EBZR_PROJECT="${PN}"
EBZR_REPO_URI="lp:~noskcaj/${PN}/gnome-desktop-3.10"
EBZR_REVISION="4028"

LICENSE="GPL-2"
SLOT="0"
IUSE="+colord +cups debug +i18n input_devices_wacom nls packagekit policykit +short-touchpad-timeout smartcard +udev"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
REQUIRED_USE="packagekit? ( udev )
		smartcard? ( udev )"
RESTRICT="mirror"

# require colord-0.1.27 dependency for connection type support
COMMON_DEPEND=">=dev-libs/glib-2.37.7:2
	dev-libs/libappindicator:=
	>=x11-libs/gtk+-3.7.8:3
	>=gnome-base/gnome-desktop-3.9:3=
	>=gnome-base/gsettings-desktop-schemas-3.9.91.1
	>=gnome-base/librsvg-2.36.2
	media-fonts/cantarell
	media-libs/fontconfig
	>=media-libs/lcms-2.2:2
	media-libs/libcanberra[gtk3]
	>=media-sound/pulseaudio-2
	sys-apps/accountsservice
	sys-apps/systemd
	>=sys-power/upower-0.9.11
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

	app-misc/geoclue:2.0
	>=dev-libs/libgweather-3.9.5:2
	>=sci-geosciences/geocode-glib-3.10
	>=sys-auth/polkit-0.103

	colord? ( >=x11-misc/colord-1.0.2:= )
	cups? ( >=net-print/cups-1.4[dbus] )
	i18n? ( >=app-i18n/ibus-1.4.99 )
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7
		x11-drivers/xf86-input-wacom )
	packagekit? ( >=app-admin/packagekit-base-0.7.4 )
	smartcard? ( >=dev-libs/nss-3.11.2 )
	udev? ( virtual/libgudev:= )"
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	>=x11-themes/gnome-themes-standard-2.91
	>=x11-themes/gnome-icon-theme-2.91
	>=x11-themes/gnome-icon-theme-symbolic-2.91
	!<gnome-base/gnome-control-center-2.22
	!<gnome-extra/gnome-color-manager-3.1.1
	!<gnome-extra/gnome-power-manager-3.1.3"
DEPEND="${COMMON_DEPEND}
	cups? ( sys-apps/sed )
	dev-libs/libxml2:2
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	x11-proto/inputproto
	x11-proto/xf86miscproto
	>=x11-proto/xproto-7.0.15"
S="${WORKDIR}/${P}"

src_unpack() {
	bzr_src_unpack
}

src_prepare() {
	bzr_src_prepare

	# https://bugzilla.gnome.org/show_bug.cgi?id=621836
	# Apparently this change severely affects touchpad usability for some
	# people, so revert it if USE=short-touchpad-timeout.
	# Revisit if/when upstream adds a setting for customizing the timeout.
	use short-touchpad-timeout &&
		epatch "${FILESDIR}/${PN}-3.7.90-short-touchpad-timeout.patch"

	# Make colord and wacom optional; requires eautoreconf
	epatch "${FILESDIR}/${PN}-optional-color-wacom.patch"

	# Correct backlight percentage #
	epatch "${FILESDIR}/${PN}_backlight-percent-fix.diff"

	# Disable build of cursor plugin #
	# This fixes the missing cursor in lightdm for gnome-3.10 #
	sed \
		-e '/cursor/d' \
		-e 's:.*disabled_plugins.*:disabled_plugins = cursor:' \
			-i plugins/Makefile.am || die

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	append-ldflags -Wl,--warn-unresolved-symbols
	append-cflags -Wno-deprecated-declarations

	gnome2_src_configure \
		--disable-static \
		--enable-man \
		$(use_enable colord color) \
		$(use_enable cups) \
		$(use_enable debug) \
		$(use_enable debug more-warnings) \
		$(use_enable i18n ibus) \
		$(use_enable nls) \
		$(use_enable packagekit) \
		$(use_enable smartcard smartcard-support) \
		$(use_enable udev gudev) \
		$(use_enable input_devices_wacom wacom)
}

src_compile() {
	gnome2_src_compile
	gcc -o gnome-settings-daemon/gnome-update-wallpaper-cache \
		debian/gnome-update-wallpaper-cache.c \
			$(pkg-config --cflags --libs glib-2.0 gdk-3.0 gdk-x11-3.0 gio-2.0 gnome-desktop-3.0) || die
}

src_install() {
	gnome2_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"

	insinto /usr/lib/unity-settings-daemon
	doins gnome-settings-daemon/gnome-update-wallpaper-cache

	prune_libtool_files --modules
}

src_test() {
	Xemake check
}
