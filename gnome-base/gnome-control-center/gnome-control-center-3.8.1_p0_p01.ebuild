EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes" # gmodule is used, which uses dlopen
VALA_MIN_API_VERSION="0.20"
VALA_USE_DEPEND="vapigen"

inherit autotools base eutils gnome2 ubuntu-versionator vala

URELEASE=
UVER_PREFIX="+logind~raring1"

DESCRIPTION="GNOME Desktop Configuration Tool patched for the Unity desktop"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="https://launchpad.net/~gnome3-team/+archive/gnome3-staging/+files/${MY_P}.orig.tar.xz
	https://launchpad.net/~gnome3-team/+archive/gnome3-staging/+files/${MY_P}-${UVER}${UVER_PREFIX}.debian.tar.gz"

LICENSE="GPL-2+"
SLOT="2"
IUSE="+bluetooth +colord +cups +gnome-online-accounts +i18n input_devices_wacom kerberos +socialweb systemd v4l"
#KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
RESTRICT="mirror"

# gnome-session-2.91.6-r1 is needed so that 10-user-dirs-update is run at login
# g-s-d[policykit] needed for bug #403527
COMMON_DEPEND="
	>=dev-libs/glib-2.35.1:2
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.7.7:3
	>=gnome-base/gsettings-desktop-schemas-3.7.2.2
	>=gnome-base/gnome-desktop-3.7.5:3=
	>=gnome-base/gnome-settings-daemon-3.6[colord?,policykit]
	>=gnome-base/libgnomekbd-2.91.91

	app-text/iso-codes
	dev-libs/libpwquality
	dev-libs/libxml2:2
	gnome-base/gnome-menus:3
	gnome-base/libgtop:2
	media-libs/fontconfig

	>=media-libs/libcanberra-0.13[gtk3]
	>=media-sound/pulseaudio-2[glib]
	>=sys-auth/polkit-0.97
	>=sys-power/upower-0.9.1
	unity-base/ubuntuone-control-panel
	>=x11-libs/libnotify-0.7.3

	>=gnome-extra/nm-applet-0.9.7.995
	>=net-misc/networkmanager-0.9.8[modemmanager]

	x11-apps/xmodmap
	x11-libs/libX11
	x11-libs/libXxf86misc
	>=x11-libs/libXi-1.2

	>=net-wireless/gnome-bluetooth-3.8.0:=
	>=x11-misc/colord-0.1.29
	cups? ( >=net-print/cups-1.4[dbus] )
	>=net-libs/gnome-online-accounts-3.8.1
	i18n? ( >=app-i18n/ibus-1.4.99 )
	kerberos? ( virtual/krb5 )
	socialweb? ( net-libs/libsocialweb )
	systemd? ( >=sys-apps/systemd-31 )
	v4l? (
		media-libs/gstreamer:1.0
		media-libs/clutter-gtk:1.0
		>=media-video/cheese-3.5.91 )
	>=dev-libs/libwacom-0.6
	>=x11-libs/libXi-1.2
"
# <gnome-color-manager-3.1.2 has file collisions with g-c-c-3.1.x
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/accountsservice-0.6.30
	x11-themes/gnome-icon-theme-symbolic
	colord? ( >=gnome-extra/gnome-color-manager-3
		  >=x11-misc/colord-0.1.29 )
	cups? (
		>=app-admin/system-config-printer-gnome-1.3.5
		net-print/cups-pk-helper )
	!systemd? (
		app-admin/openrc-settingsd
		sys-auth/consolekit )
	input_devices_wacom? ( gnome-base/gnome-settings-daemon[input_devices_wacom] )

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

	cups? ( sys-apps/sed )

	gnome-base/gnome-common
	$(vala_depend)
"
# Needed for autoreconf
#	gnome-base/gnome-common

src_prepare() {
	# Disable selected patches #
	sed \
		`# Don't use Ubuntu specific language selector settings` \
			-e 's:52_region_language.patch:#52_region_language.patch:g' \
		`# Causes build failure` \
			`# keyboard-shortcuts.c:1749:62: error: 'GTK_CELL_RENDERER_ACCEL_MODE_MODIFIER_TAP' undeclared (first use in this function)` \
			-e 's:54_enable_alt_tap_in_shortcut:#54_enable_alt_tap_in_shortcut:g' \
				-i "${WORKDIR}/debian/patches/series"

	# Make some panels optional; requires eautoreconf
	# https://bugzilla.gnome.org/697478
#	epatch "${FILESDIR}/${PN}-3.8.0-optional-r1.patch"	# Disabled as it causes Ubuntu patchset to fail #

	# https://bugzilla.gnome.org/686840
	epatch "${FILESDIR}/${PN}-3.7.4-optional-kerberos.patch"

	# Fix some absolute paths to be appropriate for Gentoo
	epatch "${FILESDIR}/${PN}-3.8.0-paths-makefiles.patch"
	epatch "${FILESDIR}/${PN}-3.8.0-paths.patch"

	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
	vala_src_prepare
	eautoreconf
	gnome2_src_prepare

	# panels/datetime/Makefile.am gets touched as a result of something in our
	# src_prepare(). We need to touch timedated{c,h} to prevent them from being
	# regenerated (bug #415901)
	[[ -f panels/datetime/timedated.h ]] && touch panels/datetime/timedated.h
	[[ -f panels/datetime/timedated.c ]] && touch panels/datetime/timedated.c
}

src_configure() {
	G2CONF="${G2CONF}
		--disable-update-mimedb
		--disable-static
		--enable-documentation
		$(use_enable bluetooth)
		$(use_enable colord color)
		$(use_enable cups)
		$(use_enable gnome-online-accounts goa)
		$(use_enable i18n ibus)
		$(use_with socialweb libsocialweb)
		$(use_enable systemd)
		$(use_with v4l cheese)
		$(use_enable input_devices_wacom wacom)"
	# FIXME: add $(use_with kerberos) support?
	if ! use kerberos; then
		G2CONF+=" KRB5_CONFIG=$(type -P true)"
	fi
	gnome2_src_configure
}
