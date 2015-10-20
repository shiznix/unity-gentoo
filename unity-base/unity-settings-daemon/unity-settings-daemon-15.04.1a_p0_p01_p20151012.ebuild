# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

URELEASE="wily"
inherit autotools base eutils flag-o-matic gnome2 virtualx ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Unity Settings Daemon"
HOMEPAGE="https://launchpad.net/unity-settings-daemon"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="+colord +cups debug fcitx +i18n input_devices_wacom nls packagekit policykit +short-touchpad-timeout smartcard +udev"
#KEYWORDS="~amd64 ~x86"
REQUIRED_USE="packagekit? ( udev )
		smartcard? ( udev )"
RESTRICT="mirror"

# require colord-0.1.27 dependency for connection type support
COMMON_DEPEND="dev-libs/glib:2
	dev-libs/libappindicator:=
	x11-libs/gtk+:3
	gnome-base/gnome-desktop:3=
	>=gnome-base/gsettings-desktop-schemas-3.9.91.1
	gnome-base/librsvg
	media-fonts/cantarell
	media-libs/fontconfig
	media-libs/lcms:2
	media-libs/libcanberra[gtk3]
	media-sound/pulseaudio
	sys-apps/accountsservice
	sys-apps/systemd
	>=sys-power/upower-0.99:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/libnotify:=
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXtst
	x11-libs/libXxf86misc

	app-misc/geoclue:2.0
	dev-libs/libgweather:2=
	sci-geosciences/geocode-glib
	sys-auth/polkit

	colord? ( x11-misc/colord:= )
	cups? ( net-print/cups[dbus] )
	fcitx? ( app-i18n/fcitx-configtool )
	i18n? ( app-i18n/ibus )
	input_devices_wacom? (
		dev-libs/libwacom
		x11-drivers/xf86-input-wacom )
	packagekit? ( app-admin/packagekit-base )
	smartcard? ( dev-libs/nss )
	udev? ( virtual/libgudev:= )"
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	x11-themes/gnome-themes-standard
	x11-themes/gnome-icon-theme
	x11-themes/gnome-icon-theme-symbolic
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

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	# Ubuntu patchset #
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"  # This needs to be applied for the debian/ directory to be present #

	# https://bugzilla.gnome.org/show_bug.cgi?id=621836
	# Apparently this change severely affects touchpad usability for some
	# people, so revert it if USE=short-touchpad-timeout.
	# Revisit if/when upstream adds a setting for customizing the timeout.
	use short-touchpad-timeout &&
		epatch "${FILESDIR}/${PN}-3.7.90-short-touchpad-timeout.patch"

	# Make colord and wacom optional; requires eautoreconf
	epatch "${FILESDIR}/${PN}-optional-color-wacom.patch"

	# Correct path to unity-settings-daemon executable in upstart files #
	sed -e 's:/usr/lib/unity-settings-daemon:/usr/libexec:g' \
		-i debian/unity-settings-daemon.user-session.{desktop,upstart}

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	append-ldflags -Wl,--warn-unresolved-symbols
	append-cflags -Wno-deprecated-declarations -I/usr/include/librsvg-2.0

	gnome2_src_configure \
		--disable-static \
		--enable-man \
		$(use_enable colord color) \
		$(use_enable cups) \
		$(use_enable debug) \
		$(use_enable debug more-warnings) \
		$(use_enable fcitx) \
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

	dodir /usr/share/hwdata
	dosym /usr/share/libgnome-desktop-3.0/pnp.ids /usr/share/hwdata/pnp.ids

	# Install upstart files #
	insinto /usr/share/upstart/xdg/autostart
	newins debian/unity-settings-daemon.user-session.desktop unity-settings-daemon.desktop
	insinto /usr/share/upstart/sessions/
	newins debian/unity-settings-daemon.user-session.upstart unity-settings-daemon.conf

	prune_libtool_files --modules
}

src_test() {
	Xemake check
}
