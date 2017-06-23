# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

URELEASE="yakkety"
inherit autotools base eutils gnome2 ubuntu-versionator vala

UURL="mirror://unity/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Unity Desktop Configuration Tool"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+bluetooth +colord +cups fcitx +gnome-online-accounts +i18n input_devices_wacom kerberos +language-selector v4l"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

# False positives caused by nested configure scripts
QA_CONFIGURE_OPTIONS=".*"

# gnome-session-2.91.6-r1 is needed so that 10-user-dirs-update is run at login
# g-s-d[policykit] needed for bug #403527
# kerberos unfortunately means mit-krb5; build fails with heimdal
# udev could be made optional, only conditions gsd-device-panel
# (mouse, keyboards, touchscreen, etc)
COMMON_DEPEND="
	>=dev-libs/glib-2.39.91:2[dbus]
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.15:3[X]
	>=gnome-base/gsettings-desktop-schemas-3.15.4
	>=gnome-base/gnome-desktop-3.17.4:3=
	>=gnome-base/gnome-settings-daemon-3.8.3[colord?]

	app-admin/apg
	app-text/iso-codes
	dev-libs/libpwquality
	dev-libs/libtimezonemap
	dev-libs/libxml2:2
	gnome-base/gnome-menus:3
	gnome-base/libgtop:2=
	media-libs/fontconfig

	>=media-libs/libcanberra-0.13[gtk3]
	>=media-sound/pulseaudio-2[glib]
	>=sys-auth/polkit-0.97
	>=sys-power/upower-0.99:=
	unity-base/unity-settings-daemon[colord?,input_devices_wacom?]
	>=x11-libs/libnotify-0.7.3:0=

	>=gnome-extra/nm-applet-0.9.7.995
	>=net-misc/networkmanager-0.9.8
	net-libs/geonames

	virtual/libgudev
	virtual/opengl
	x11-apps/xmodmap
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/libXxf86misc
	>=x11-libs/libXi-1.2

	dev-util/desktop-file-utils
	media-libs/mesa
	net-libs/webkit-gtk:4
	unity-indicators/indicator-datetime
	x11-libs/libXft
	x11-libs/libxkbfile
	x11-libs/libxklavier

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.18.0:= )
	colord? (
		>=x11-misc/colord-0.1.34:0=
		>=x11-libs/colord-gtk-0.1.24 )
	cups? (
		>=net-print/cups-1.4[dbus]
		|| ( >=net-fs/samba-3.6.14-r1[smbclient] >=net-fs/samba-4.0.0[client] ) )
	fcitx? ( app-i18n/fcitx )
	gnome-online-accounts? ( unity-base/gnome-control-center-signon )
	i18n? (
		>=app-i18n/ibus-1.5.2
		>=gnome-base/libgnomekbd-3 )
	input_devices_wacom? ( >=dev-libs/libwacom-0.7 )
	kerberos? ( app-crypt/mit-krb5 )
	v4l? (
		media-libs/gstreamer:1.0
		media-libs/clutter-gtk:1.0
		>=media-video/cheese-3.5.91 )

	$(vala_depend)"
RDEPEND="${COMMON_DEPEND}
	|| ( ( app-admin/openrc-settingsd sys-auth/consolekit ) >=sys-apps/systemd-31 )
	>=sys-apps/accountsservice-0.6.39
	x11-themes/gnome-icon-theme-symbolic

	gnome-extra/mousetweaks
	unity-base/gsettings-ubuntu-touch-schemas
	x11-themes/adwaita-icon-theme

	colord? ( >=gnome-extra/gnome-color-manager-3 )
	cups? (
		app-admin/system-config-printer
		net-print/cups-pk-helper )
	gnome-online-accounts? ( net-libs/gnome-online-accounts[uoa] )
	language-selector? ( >=gnome-base/gnome-control-center-3.18 )

	!<gnome-base/gdm-2.91.94
	!<gnome-extra/gnome-color-manager-3.1.2
	!gnome-extra/gnome-media[pulseaudio]
	!<gnome-extra/gnome-media-2.32.0-r300
	!<net-wireless/gnome-bluetooth-3.3.2
"
# PDEPEND to avoid circular dependency
PDEPEND=">=gnome-base/gnome-session-2.91.6-r1"

DEPEND="${COMMON_DEPEND}
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto

	dev-libs/libxml2:2
	dev-libs/libxslt
	>=dev-util/intltool-0.40.1
	>=sys-devel/gettext-0.17
	virtual/pkgconfig

	gnome-base/gnome-common
"
# Needed for autoreconf
#	gnome-base/gnome-common

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}/01_unity-cc-optional-bt-colord-kerberos-wacom.patch"
	epatch "${FILESDIR}/02_remove_ubuntu_info_branding.patch"
	epatch "${FILESDIR}/03_enable_printer_panel-v2.patch"

	# If a .desktop file does not have inline translations, fall back #
	#  to calling gettext #
	find ${WORKDIR} -type f -name "*.desktop*" \
		-exec sh -c 'sed -i -e "/\[Desktop Entry\]/a X-GNOME-Gettext-Domain=${PN}" "$1"' -- {} \;

	eautoreconf
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	# cheese is disabled as it can cause gnome-control-center to segfault (and Ubuntu disable it anyway) #
	# gnome-online-accounts is disabled as we use Ubuntu's online accounts method #
	gnome2_src_configure \
		--disable-update-mimedb \
		--disable-static \
		--enable-documentation \
		--without-cheese \
		$(use_enable bluetooth) \
		$(use_enable colord color) \
		$(use_enable cups) \
		$(use_enable fcitx) \
		$(use_enable i18n ibus) \
		$(use_enable input_devices_wacom wacom) \
		$(use_enable kerberos)
}

src_install() {
	gnome2_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"

	# Remove libgnome-bluetooth.so symlink as is provided by net-wireless/gnome-bluetooth #
	rm "${ED}usr/$(get_libdir)/libgnome-bluetooth.so" 2>/dev/null

	# Remove /usr/share/pixmaps/faces/ as is provided by gnome-base/gnome-control-center #
	rm -rf "${ED}usr/share/pixmaps/faces"

	# Add Region and Language locale support #
	#  Unable to use Unity's language-selector as it needs a complete apt/dpkg enabled system #
	if use language-selector; then
		exeinto /usr/bin
		doexe "${FILESDIR}/unity-cc-region"
		insinto /usr/share/applications
		doins "${FILESDIR}/language-selector.desktop"
	fi
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
