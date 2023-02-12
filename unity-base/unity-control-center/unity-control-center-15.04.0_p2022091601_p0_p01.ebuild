# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="kinetic"
inherit autotools gnome2 ubuntu-versionator vala xdg-utils

UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Unity Desktop Configuration Tool"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+bluetooth +branding +colord +cups +fcitx +gnome-online-accounts +i18n input_devices_wacom +kerberos networkmanager +samba +v4l +webkit"
REQUIRED_USE="samba? ( cups )"
#KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

# gnome-session-2.91.6-r1 is needed so that 10-user-dirs-update is run at login
# g-s-d[policykit] needed for bug #403527
# kerberos unfortunately means mit-krb5; build fails with heimdal
# udev could be made optional, only conditions gsd-device-panel
# (mouse, keyboards, touchscreen, etc)
DEPEND="
	>=dev-libs/glib-2.39.91:2[dbus]
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.15:3[X]
	>=gnome-base/gsettings-desktop-schemas-3.15.4
	>=gnome-base/gnome-desktop-3.17.4:3=
	>=gnome-base/gnome-settings-daemon-3.8.3

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

	net-libs/geonames

	dev-libs/libgudev
	virtual/opengl
	x11-apps/xmodmap
	x11-libs/cairo
	x11-libs/libX11
	>=x11-libs/libXi-1.2

	dev-util/desktop-file-utils
	media-libs/mesa
	unity-indicators/indicator-datetime
	x11-libs/libXft
	x11-libs/libxkbfile
	x11-libs/libxklavier

	>=net-wireless/gnome-bluetooth-3.18.0:=
	>=x11-misc/colord-0.1.34:0=
	>=x11-libs/colord-gtk-0.1.24
	cups? (	>=net-print/cups-1.4[dbus]
		samba? ( || ( >=net-fs/samba-3.6.14-r1[smbclient] >=net-fs/samba-4.0.0[client] ) ) )
	fcitx? ( app-i18n/fcitx )
	gnome-online-accounts? ( net-libs/gnome-online-accounts )
	i18n? (
		>=app-i18n/ibus-1.5.2
		>=gnome-base/libgnomekbd-3 )
	>=dev-libs/libwacom-0.7
	app-crypt/mit-krb5
	networkmanager? (
		>=gnome-extra/nm-applet-1.2.0
		>=net-misc/modemmanager-0.7
		>=net-misc/networkmanager-1.2.0 )
	v4l? (
		media-libs/gstreamer:1.0
		media-libs/clutter-gtk:1.0
		>=media-video/cheese-3.5.91 )
	webkit? ( net-libs/webkit-gtk:4 )

	$(vala_depend)"
RDEPEND="${DEPEND}
	|| ( ( app-admin/openrc-settingsd sys-auth/consolekit ) >=sys-apps/systemd-31 )
	>=sys-apps/accountsservice-0.6.39

	gnome-extra/mousetweaks
	unity-base/gsettings-ubuntu-touch-schemas
	x11-themes/adwaita-icon-theme

	>=gnome-extra/gnome-color-manager-3
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

# Soft block unity-base/gnome-control-center-signon as it installs conflicting 'Online Accounts' settings tile (use GOA not UOA) #
BDEPEND="!unity-base/gnome-control-center-signon
	x11-base/xorg-proto

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
	eapply "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"      # This needs to be applied for the debian/ directory to be present #
	ubuntu-versionator_src_prepare

	# Fudge a pass on broken hostname-helper test (see https://bugzilla.gnome.org/show_bug.cgi?id=650342) #
	echo > panels/info/hostnames-test.txt

	eapply "${FILESDIR}/01_${PN}-2019-langselector.patch" # Based on g-c-c v3.24 Region & Language panel
#	eapply "${FILESDIR}/02_${PN}-2020-optional-bt-colord-kerberos-wacom-webkit.patch"

	# Fix typo #
	sed -i \
		-e "/Name=/{s/Sha­ring/Sharing/}" \
		panels/sharing/unity-sharing-panel.desktop.in.in

	if use branding; then
		cp "${FILESDIR}"/GnomeLogoVerticalMedium.svg panels/info/
		sed -i \
			-e "/gtk_widget_hide (WID (\"version_label\")/d" \
			-e "s/Version %s/unity-gentoo ${UVER_RELEASE} ${URELEASE^}/" \
			panels/info/cc-info-panel.c
		sed -i \
			-e "s/UbuntuLogo.png/GnomeLogoVerticalMedium.svg/" \
			panels/info/info.ui
	fi

	use cups \
		&& eapply "${FILESDIR}/${PN}-printers-fix_launcher.patch"

	if use gnome-online-accounts; then
		# Needed by gnome-calendar #
		eapply "${FILESDIR}/${PN}-online-accounts-enable_passing_data.patch"

		# Use .desktop Comment from g-c-c we can translate #
		sed -i \
			-e "/Comment/{s/your online accounts/to your online accounts and decide what to use them for/}" \
			panels/online-accounts/unity-online-accounts-panel.desktop.in.in
	fi

	# Fix metadata path #
	sed -i \
		-e "/appdatadir/{s/\/appdata/\/metainfo/}" \
		shell/appdata/Makefile.am

	# Disable all language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	> po/LINGUAS

	eautoreconf
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-update-mimedb \
		--disable-static \
		--enable-documentation \
		$(use_enable cups) \
		$(use_enable fcitx) \
		$(use_enable i18n ibus) \
		$(use_enable gnome-online-accounts onlineaccounts) \
		$(use_with v4l cheese) \
		$(use_enable webkit)
}

src_install() {
	gnome2_src_install

	# Remove libgnome-bluetooth.so symlink as is provided by net-wireless/gnome-bluetooth #
	rm "${ED}/usr/$(get_libdir)/libgnome-bluetooth.so" 2>/dev/null

	# Remove /usr/share/pixmaps/faces/ as is provided by gnome-base/gnome-control-center #
	rm -rf "${ED}/usr/share/pixmaps/faces"

	# Remove cc-remote-login-helper as is provided by gnome-base/gnome-control-center #
	rm "${ED}/usr/libexec/cc-remote-login-helper" 2> /dev/null

	# If a .desktop file does not have inline
	# translations, fall back to calling gettext
	local file
	for file in "${ED}"/usr/share/applications/*.desktop; do
		echo "X-GNOME-Gettext-Domain=${PN}" >> "${file}"
	done

	if ! use branding; then
		pushd "${WORKDIR}"/panels/info 1>/dev/null
			./logo-generator --logo UbuntuLogoBlank.png --text "ubuntu ${UVER_RELEASE}" --output "${ED}"/usr/share/"${PN}"/ui/UbuntuLogo.png
		popd 1>/dev/null
	fi
}

pkg_preinst() { gnome2_icon_savelist; }

pkg_postinst() {
	xdg_icon_cache_update
	if ! use webkit; then
		echo
		elog "Searching in the dash - Legal notice:"
		elog "file:///usr/share/unity-control-center/searchingthedashlegalnotice.html"
		echo
	fi
}

pkg_postrm() { xdg_icon_cache_update; }
