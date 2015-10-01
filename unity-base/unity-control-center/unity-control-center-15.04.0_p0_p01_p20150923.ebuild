# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

URELEASE="wily"
inherit autotools base eutils gnome2 ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Unity Desktop Configuration Tool"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+cups +gnome-online-accounts +i18n v4l"
#KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

# False positives caused by nested configure scripts
QA_CONFIGURE_OPTIONS=".*"

# gnome-session-2.91.6-r1 is needed so that 10-user-dirs-update is run at login
# g-s-d[policykit] needed for bug #403527
#
# gnome-shell/gnome-control-center/mutter/gnome-settings-daemon better to be in sync for 3.8.3
# https://mail.gnome.org/archives/gnome-announce-list/2013-June/msg00005.html
COMMON_DEPEND="
	>=dev-libs/glib-2.37.2:2
	>=x11-libs/gdk-pixbuf-2.23.0:2

	>=x11-libs/gtk+-3.9.12:3
	>=gnome-base/gsettings-desktop-schemas-3.9.91
	>=gnome-base/gnome-desktop-3.9.90:3=
	>=gnome-base/libgnomekbd-2.91.91

	>=dev-libs/libpwquality-1.2.2
	app-admin/apg
	app-text/iso-codes
	dev-libs/libpwquality
	dev-libs/libtimezonemap
	dev-libs/libxml2:2
	gnome-base/gnome-menus:3
	gnome-base/libgtop:2
	media-libs/fontconfig

	>=media-libs/libcanberra-0.13[gtk3]
	>=media-sound/pulseaudio-2[glib]
	>=sys-auth/polkit-0.97
	>=sys-power/upower-0.99:=
	unity-base/gnome-control-center-signon
	unity-base/unity-settings-daemon[colord,policykit]
	virtual/krb5
	>=x11-libs/libnotify-0.7.3:0=

	>=gnome-extra/nm-applet-0.9.7.995
	>=net-misc/networkmanager-0.9.8[modemmanager]
	>=net-misc/modemmanager-0.7.990

	virtual/opengl
	x11-apps/xmodmap
	x11-libs/libX11
	x11-libs/libXxf86misc
	>=x11-libs/libXi-1.2

	net-wireless/gnome-bluetooth:=

	net-libs/libsoup:2.4
	>=x11-misc/colord-0.1.34:0=
	>=x11-libs/colord-gtk-0.1.24

	cups? (
		>=net-print/cups-1.4[dbus]
		|| ( >=net-fs/samba-3.6.14-r1[smbclient] >=net-fs/samba-4.0.0[client] ) )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.9.90 )
	i18n? ( >=app-i18n/ibus-1.5.2 )
	v4l? (
		media-libs/gstreamer:1.0
		media-libs/clutter-gtk:1.0
		>=media-video/cheese-3.5.91 )

	>=dev-libs/libwacom-0.7
	>=media-libs/clutter-1.11.3:1.0
	media-libs/clutter-gtk:1.0
	>=x11-libs/libXi-1.2

	$(vala_depend)"
RDEPEND="${COMMON_DEPEND}
	|| ( ( app-admin/openrc-settingsd sys-auth/consolekit ) >=sys-apps/systemd-31 )
	>=sys-apps/accountsservice-0.6.30
	x11-themes/gnome-icon-theme-symbolic
	>=gnome-extra/gnome-color-manager-3
	cups? ( app-admin/system-config-printer
		net-print/cups-pk-helper )
	unity-base/unity-settings-daemon[input_devices_wacom]

	>=gnome-base/gnome-control-center-3.10

	!<gnome-base/gdm-2.91.94
	!<gnome-extra/gnome-color-manager-3.1.2
	!gnome-extra/gnome-media[pulseaudio]
	!<gnome-extra/gnome-media-2.32.0-r300
	!<net-wireless/gnome-bluetooth-3.3.2"

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

	cups? ( sys-apps/sed )

	gnome-base/gnome-common"
# Needed for autoreconf
#	gnome-base/gnome-common

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	epatch "${FILESDIR}/02_remove_ubuntu_info_branding.patch"
	epatch "${FILESDIR}/03_enable_printer_panel.patch"

	eautoreconf
	gnome2_src_prepare
	vala_src_prepare

	# panels/datetime/Makefile.am gets touched as a result of something in our
	# src_prepare(). We need to touch timedated{c,h} to prevent them from being
	# regenerated (bug #415901)
	[[ -f panels/datetime/timedated.h ]] && touch panels/datetime/timedated.h
	[[ -f panels/datetime/timedated.c ]] && touch panels/datetime/timedated.c
}

src_configure() {
	# cheese is disabled as it can cause gnome-control-center to segfault (and Ubuntu disable it anyway) #
	# gnome-online-accounts is disabled as we use Ubuntu's online accounts method #
	gnome2_src_configure \
		--disable-update-mimedb \
		--disable-static \
		--enable-documentation \
		--without-cheese \
		$(use_enable cups) \
		$(use_enable i18n ibus)
}

src_install() {
	gnome2_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"

	# Remove libgnome-bluetooth.so symlink as is provided by net-wireless/gnome-bluetooth #
	rm "${ED}usr/$(get_libdir)/libgnome-bluetooth.so"

	# Add Region and Language locale support #
	#  Unable to use Unity's language-selector as it needs a complete apt/dpkg enabled system #
	exeinto /usr/bin
	doexe "${FILESDIR}/unity-cc-region"
	insinto /usr/share/applications
	doins "${FILESDIR}/unity-language-selector.desktop"
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
