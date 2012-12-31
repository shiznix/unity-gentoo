EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes" # gmodule is used, which uses dlopen

inherit autotools base eutils gnome2

# Prefixing version with 99. so as not to break the overlay with upgrades in the main tree #
MY_PV="${PV/99./}"
MY_P="${PN}_${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/g/${PN}"
UVER="0ubuntu9"
URELEASE="quantal"
MY_P="${MY_P/daemon-/daemon_}"

DESCRIPTION="GNOME Desktop Configuration Tool patched for the Unity desktop"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2+"
SLOT="2"
IUSE="+bluetooth +colord +cups +gnome-online-accounts +i18n kerberos +networkmanager +socialweb systemd v4l wacom"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
fi

# XXX: NetworkManager-0.9 support is automagic, make hard-dep once it's released
#
# gnome-session-2.91.6-r1 is needed so that 10-user-dirs-update is run at login
# g-s-d[policykit] needed for bug #403527
COMMON_DEPEND="
	>=dev-libs/glib-2.31:2
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-99.3.5.13:3
	>=gnome-base/gsettings-desktop-schemas-99.3.5.91
	>=gnome-base/gnome-desktop-3.5.91:3=
	>=gnome-base/gnome-settings-daemon-99.3.6[colord?,policykit]
	>=gnome-base/libgnomekbd-2.91.91

	app-text/iso-codes
	dev-libs/libpwquality
	dev-libs/libxml2:2
	>=gnome-base/gnome-menus-99.3.4.0:3
	gnome-base/libgtop:2
	media-libs/fontconfig

	>=media-libs/libcanberra-0.13[gtk3]
	>=media-sound/pulseaudio-2[glib]
	>=sys-auth/polkit-0.97
	>=sys-power/upower-0.9.1
	unity-base/ubuntuone-control-panel
	>=x11-libs/libnotify-0.7.3

	x11-apps/xmodmap
	x11-libs/libX11
	x11-libs/libXxf86misc
	>=x11-libs/libxklavier-5.1
	>=x11-libs/libXi-1.2

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.5.5:= )
	colord? ( >=x11-misc/colord-0.1.8 )
	cups? ( >=net-print/cups-1.4[dbus] )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.5.90 )
	i18n? ( >=app-i18n/ibus-1.4.99 )
	kerberos? ( virtual/krb5 )
	networkmanager? (
		>=gnome-extra/nm-applet-99.0.9.1.90
		>=net-misc/networkmanager-0.8.997 )
	socialweb? ( net-libs/libsocialweb )
	systemd? ( >=sys-apps/systemd-31 )
	v4l? (
		media-libs/gstreamer:1.0
		media-libs/clutter-gtk:1.0
		>=media-video/cheese-3.5.91 )
	wacom? (
		>=dev-libs/libwacom-0.6
		>=x11-libs/libXi-1.2 )
"
# <gnome-color-manager-3.1.2 has file collisions with g-c-c-3.1.x
RDEPEND="${COMMON_DEPEND}
	app-admin/apg
	sys-apps/accountsservice
	x11-themes/gnome-icon-theme-symbolic
	colord? ( >=gnome-extra/gnome-color-manager-3 )
	cups? (
		>=app-admin/system-config-printer-gnome-1.3.5
		net-print/cups-pk-helper )
	!systemd? (
		app-admin/openrc-settingsd
		sys-auth/consolekit )
	wacom? ( gnome-base/gnome-settings-daemon[wacom] )

	!<gnome-base/gdm-2.91.94
	!<gnome-extra/gnome-color-manager-3.1.2
	!gnome-extra/gnome-media[pulseaudio]
	!<gnome-extra/gnome-media-2.32.0-r300
	!<net-wireless/gnome-bluetooth-3.3.2
"
# PDEPEND to avoid circular dependency
PDEPEND=">=gnome-base/gnome-session-99.2.91.6-r1"
DEPEND="${COMMON_DEPEND}
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto

	dev-libs/libxml2:2
	dev-libs/libxslt
	>=dev-util/intltool-0.40.1
	>=sys-devel/gettext-0.17
	virtual/pkgconfig

	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.10.1

	cups? ( sys-apps/sed )

	gnome-base/gnome-common
"
# Needed for autoreconf
#	gnome-base/gnome-common

src_prepare() {
	# Make some panels optional; requires eautoreconf
	epatch "${FILESDIR}/${PN}-3.5.91-optional-bt-colord-goa-wacom.patch"
	# https://bugzilla.gnome.org/show_bug.cgi?id=686840
	epatch "${FILESDIR}/${PN}-3.5.91-optional-kerberos.patch"
	# Fix some absolute paths to be appropriate for Gentoo
	epatch "${FILESDIR}/${PN}-3.5.91-gentoo-paths.patch"
	# Needed for g-c-c 3.6.3 and PulseAudio >2.1. Remove in 3.6.4.
	epatch "${FILESDIR}/${P}-pulseaudio-3-fix.patch"

	# Disable selected patches #
	sed \
		`# Causes clicking on 'User Accounts' to crash gnome-control-center` \
			-e 's:52_ubuntu_language_list_mods:^#52_ubuntu_language_list_mods:g' \
		`# Disable Ubuntu branding` \
			-e 's:56_use_ubuntu_info_branding:#56_use_ubuntu_info_branding:g' \
		-i "${WORKDIR}/debian/patches/series"
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare

	# Fix printer settings visibility #
	sed -e 's:OnlyShowIn=GNOME;:OnlyShowIn=GNOME;Unity;:g' \
		-i panels/printers/gnome-printers-panel.desktop.in.in
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
		$(use_enable wacom)"
	# XXX: $(use_with kerberos) # for 3.7.x
	if ! use kerberos; then
		G2CONF+=" KRB5_CONFIG=$(type -P true)"
	fi
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	gnome2_src_configure
}

