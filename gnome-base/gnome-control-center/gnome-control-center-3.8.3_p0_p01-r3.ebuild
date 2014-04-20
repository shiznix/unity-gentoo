# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

inherit autotools base eutils gnome2 ubuntu-versionator

MY_P="${PN}_${PV}"
S="${WORKDIR}/${PN}-${PV}"

UURL="https://github.com/shiznix/unity-gentoo/raw/master/files"
URELEASE="saucy"
UVER_PREFIX="~raring2"

DESCRIPTION="GNOME Desktop Configuration Tool patched for the Unity desktop"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="http://ftp.gnome.org/pub/gnome/sources/${PN}/3.8/${PN}-${PV}.tar.xz
	${UURL}/${MY_P}-${UVER}${UVER_PREFIX}.debian.tar.gz"

LICENSE="GPL-2+"
SLOT="2"
IUSE="+bluetooth +colord +cups +gnome-online-accounts +i18n input_devices_wacom kerberos modemmanager +socialweb v4l"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
fi
RESTRICT="mirror"

# False positives caused by nested configure scripts
QA_CONFIGURE_OPTIONS=".*"

# gnome-session-2.91.6-r1 is needed so that 10-user-dirs-update is run at login
# g-s-d[policykit] needed for bug #403527
#
# gnome-shell/gnome-control-center/mutter/gnome-settings-daemon better to be in sync for 3.8.3
# https://mail.gnome.org/archives/gnome-announce-list/2013-June/msg00005.html
COMMON_DEPEND="
	>=dev-libs/glib-2.35.1:2
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.7.10:3
	>=gnome-base/gsettings-desktop-schemas-3.7.2.2
	>=gnome-base/gnome-desktop-3.7.5:3=
	>=gnome-base/gnome-settings-daemon-3.8.3[colord?,policykit]
	>=gnome-base/libgnomekbd-2.91.91

	dev-libs/libtimezonemap

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
	>=x11-libs/libnotify-0.7.3:0=

	>=gnome-extra/nm-applet-0.9.7.995
	>=net-misc/networkmanager-0.9.8[modemmanager?]

	virtual/opengl
	x11-apps/xmodmap
	x11-libs/libX11
	x11-libs/libXxf86misc
	>=x11-libs/libXi-1.2

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.5.5:= )
	colord? ( >=x11-misc/colord-0.1.29 )
	cups? (
		>=net-print/cups-1.4[dbus]
		|| ( >=net-fs/samba-3.6.14-r1[smbclient] >=net-fs/samba-4.0.0[client] ) )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.8.1 )
	i18n? ( >=app-i18n/ibus-1.4.99 )
	kerberos? ( virtual/krb5 )
	modemmanager? ( >=net-misc/modemmanager-0.7.990 )
	socialweb? ( net-libs/libsocialweb )
	v4l? (
		media-libs/gstreamer:1.0
		media-libs/clutter-gtk:1.0
		>=media-video/cheese-3.5.91 )
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7
		>=x11-libs/libXi-1.2 )
"
# <gnome-color-manager-3.1.2 has file collisions with g-c-c-3.1.x
RDEPEND="${COMMON_DEPEND}
	|| ( ( app-admin/openrc-settingsd sys-auth/consolekit ) >=sys-apps/systemd-31 )
	>=sys-apps/accountsservice-0.6.30
	x11-themes/gnome-icon-theme-symbolic
	colord? (
		>=gnome-extra/gnome-color-manager-3
		>=x11-misc/colord-0.1.29
		>=x11-libs/colord-gtk-0.1.24 )
	cups? (
		>=app-admin/system-config-printer-gnome-1.3.5
		net-print/cups-pk-helper )
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
"
# Needed for autoreconf
#	gnome-base/gnome-common

src_prepare() {
	# Make some panels optional; requires eautoreconf
	# https://bugzilla.gnome.org/697478
	epatch "${FILESDIR}/${PN}-3.8.0-optional-r1.patch"

	# https://bugzilla.gnome.org/686840
	epatch "${FILESDIR}/${PN}-3.7.4-optional-kerberos.patch"

	# Fix some absolute paths to be appropriate for Gentoo
	epatch "${FILESDIR}/${PN}-3.8.0-paths-makefiles.patch"
	epatch "${FILESDIR}/${PN}-3.8.0-paths.patch"

	# Make modemmanager optional, bug 463852, upstream bug #700145
	epatch "${FILESDIR}/${PN}-3.8.1.5-optional-modemmanager.patch"

	# Fix crash of 'Details' entry when running as guest in VirtualBox
	epatch "${FILESDIR}/${PN}-3.8.3-fix-details-crash.patch"

	# Use 'dev-libs/libtimezonemap' instead of built in timezonemap implementation
	epatch "${FILESDIR}/${PN}-3.8.3-use-libtimezonemap.patch"

	# Disable selected patches #
	sed \
		`# Ubuntu have not yet ported to the latest version of IBus` \
			-e 's:revert_new_ibus_keyboard_use.patch:#revert_new_ibus_keyboard_use.patch:g' \
		`# Avoid Ubuntu's package management` \
			-e 's:05_run_update_manager.patch:#05_run_update_manager.patch:g' \
		`# Don't patch out Gnome's Region and Language settings, Ubuntu's Language setting requires apt/dpkg` \
			-e 's:10_keyboard_layout_on_unity.patch:#10_keyboard_layout_on_unity.patch:g' \
		`# Don't use Ubuntu specific region and language selector settings` \
			-e 's:52_region_language.patch:#52_region_language.patch:g' \
		`# Disable Ubuntu branding` \
			-e 's:56_use_ubuntu_info_branding:#56_use_ubuntu_info_branding:g' \
		`# Don't patch out Gnome's printer settings panel (indicator-printers doesn't work)` \
			-e 's:91_unity_no_printing_panel:#91_unity_no_printing_panel:g' \
		`# Other Ubuntu specific patches to disable` \
			-e 's:62_update_translations_template.patch:#62_update_translations_template.patch:g' \
			-e 's:92_ubuntu_system_proxy.patch:#92_ubuntu_system_proxy.patch:g' \
			-e 's:revert_git_info_packagekit_api.patch:#revert_git_info_packagekit_api.patch:g' \
			-e 's:ubuntu_region_packagekit.patch:#ubuntu_region_packagekit.patch:g' \
			-e 's:ubuntu_region_install_dialog.patch:#ubuntu_region_install_dialog.patch:g' \
				-i "${WORKDIR}/debian/patches/series"
		for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
			PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
		done
	base_src_prepare

	# 'ubuntu_external_panels.patch' allows customisation of g-c-c #
	# The hardcoded launchers in the patch that are never used, give context for strip and replace #
	sed -e 's:landscape-client-settings:unity-tweak-tool:' \
		-i shell/cc-panel-loader.c

	# Gentoo handles completions in a different directory, bug #465094
	sed -i 's|^completiondir =.*|completiondir = $(datadir)/bash-completion|' \
		shell/Makefile.am || die "sed completiondir failed"

	eautoreconf
	gnome2_src_prepare

	# panels/datetime/Makefile.am gets touched as a result of something in our
	# src_prepare(). We need to touch timedated{c,h} to prevent them from being
	# regenerated (bug #415901)
	[[ -f panels/datetime/timedated.h ]] && touch panels/datetime/timedated.h
	[[ -f panels/datetime/timedated.c ]] && touch panels/datetime/timedated.c
}

src_configure() {
	# cheese is disabled as it can cause gnome-control-center to segfault (and Ubuntu disable it anyway) #
	# gnome-online-accounts is disabled as we use Ubuntu's online accounts method #
	# FIXME: add $(use_with kerberos) support?
	! use kerberos && G2CONF+=" KRB5_CONFIG=$(type -P true)"

	gnome2_src_configure \
		--disable-update-mimedb \
		--disable-static \
		--enable-documentation \
		--disable-goa \
		--without-cheese \
		$(use_enable bluetooth) \
		$(use_enable colord color) \
		$(use_enable cups) \
		$(use_enable i18n ibus) \
		$(use_enable modemmanager) \
		$(use_with socialweb libsocialweb) \
		$(use_enable input_devices_wacom wacom) \
		$(use_with socialweb libsocialweb)
}
