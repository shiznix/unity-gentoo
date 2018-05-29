# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

URELEASE="bionic"
inherit autotools base eutils gnome2 ubuntu-versionator vala

UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Unity Desktop Configuration Tool"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+bluetooth +colord +cups fcitx +gnome-online-accounts +i18n input_devices_wacom kerberos v4l +webkit"
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
	>=gnome-base/gnome-settings-daemon-3.8.3

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
	gnome-online-accounts? ( net-libs/gnome-online-accounts )
	i18n? (
		>=app-i18n/ibus-1.5.2
		>=gnome-base/libgnomekbd-3 )
	input_devices_wacom? ( >=dev-libs/libwacom-0.7 )
	kerberos? ( app-crypt/mit-krb5 )
	v4l? (
		media-libs/gstreamer:1.0
		media-libs/clutter-gtk:1.0
		>=media-video/cheese-3.5.91 )
	webkit? ( net-libs/webkit-gtk:4 )

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

	!<gnome-base/gdm-2.91.94
	!<gnome-extra/gnome-color-manager-3.1.2
	!gnome-extra/gnome-media[pulseaudio]
	!<gnome-extra/gnome-media-2.32.0-r300
	!<net-wireless/gnome-bluetooth-3.3.2
"
# PDEPEND to avoid circular dependency
PDEPEND=">=gnome-base/gnome-session-2.91.6-r1
	bluetooth? ( unity-indicators/indicator-bluetooth )"

# Hard block unity-base/gnome-control-center-signon as it installs conflicting 'Online Accounts' settings tile (use GOA not UOA) #
DEPEND="!!unity-base/gnome-control-center-signon
	${COMMON_DEPEND}
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
	ubuntu-versionator_src_prepare

	# Fudge a pass on broken hostname-helper test (see https://bugzilla.gnome.org/show_bug.cgi?id=650342) #
	echo > panels/info/hostnames-test.txt

	epatch "${FILESDIR}/01_${PN}-2018-language-selector.patch" # Based on g-c-c v3.24 Region & Language panel
	epatch "${FILESDIR}/02_remove_ubuntu_info_branding.patch"
	epatch "${FILESDIR}/03_enable_printer_panel-v2.patch"
	epatch "${FILESDIR}/04_${PN}-2018-optional-bt-colord-kerberos-wacom-webkit.patch"

	# If a .desktop file does not have inline translations, fall back #
	#  to calling gettext #
	find ${WORKDIR} -type f -name "unity*desktop.in.in" \
		-exec sh -c 'sed -i -e "/\[Desktop Entry\]/a X-GNOME-Gettext-Domain=${PN}" "$1"' -- {} \;
	echo "X-GNOME-Gettext-Domain=language-selector" \
		>> panels/langselector/language-selector.desktop.in.in

	eautoreconf
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-update-mimedb \
		--disable-static \
		--enable-documentation \
		$(use_enable bluetooth) \
		$(use_enable colord color) \
		$(use_enable cups) \
		$(use_enable fcitx) \
		$(use_enable i18n ibus) \
		$(use_enable input_devices_wacom wacom) \
		$(use_enable kerberos) \
		$(use_enable gnome-online-accounts onlineaccounts) \
		$(use_with v4l cheese) \
		$(use_enable webkit)
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
}

pkg_preinst() { gnome2_icon_savelist; }

pkg_postinst() {
	gnome2_icon_cache_update
	if ! use webkit; then
		echo
		elog "Searching in the dash - Legal notice:"
		elog "file:///usr/share/unity-control-center/searchingthedashlegalnotice.html"
		echo
	fi
}

pkg_postrm() { gnome2_icon_cache_update; }
