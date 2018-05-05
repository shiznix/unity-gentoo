# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="artful-updates"
inherit autotools eutils gnome2 systemd ubuntu-versionator

MY_P="${PN}_${PV}"
S="${WORKDIR}/${PN}-${PV}"

UURL="mirror://unity/pool/main/g/${PN}"

DESCRIPTION="Gnome session manager patched for the Unity desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-session"
SRC_URI="http://ftp.gnome.org/pub/gnome/sources/${PN}/3.26/${PN}-${PV}.tar.xz
	${UURL}/${MY_P}-${UVER}${UVER_PREFIX}.debian.tar.xz"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc elibc_FreeBSD ipv6 systemd wayland"
RESTRICT="mirror"

# x11-misc/xdg-user-dirs{,-gtk} are needed to create the various XDG_*_DIRs, and
# create .config/user-dirs.dirs which is read by glib to get G_USER_DIRECTORY_*
# xdg-user-dirs-update is run during login (see 10-user-dirs-update-gnome below).
# gdk-pixbuf used in the inhibit dialog
COMMON_DEPEND="
	>=dev-libs/glib-2.46.0:2[dbus]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.18.0:3
	>=dev-libs/json-glib-0.10
	>=gnome-base/gnome-desktop-3.18:3=
	elibc_FreeBSD? ( dev-libs/libexecinfo )

	media-libs/mesa[egl,gles2]

	media-libs/libepoxy
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libXau
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	x11-misc/xdg-user-dirs
	x11-misc/xdg-user-dirs-gtk
	x11-apps/xdpyinfo

	systemd? ( >=sys-apps/systemd-183:0= )
"
# Pure-runtime deps from the session files should *NOT* be added here
# Otherwise, things like gdm pull in gnome-shell
# gnome-themes-standard is needed for the failwhale dialog themeing
# sys-apps/dbus[X] is needed for session management
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-settings-daemon-3.23.2
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	x11-themes/adwaita-icon-theme
	sys-apps/dbus[X]
	!systemd? (
		sys-auth/consolekit
		>=dev-libs/dbus-glib-0.76
	)
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/intltool-0.40.6
	>=sys-devel/gettext-0.10.40
	virtual/pkgconfig
	!<gnome-base/gdm-2.20.4
	doc? (
		app-text/xmlto
		dev-libs/libxslt )
"
# gnome-common needed for eautoreconf
# gnome-base/gdm does not provide gnome.desktop anymore

src_prepare() {
	# Remove gnome-shell from required components #
	sed -e "s/org.gnome.Shell;//" \
		-i "${WORKDIR}/debian/patches/50_ubuntu_sessions.patch" || die

	ubuntu-versionator_src_prepare

	# Desktop Session is named 'unity' #
	sed -e 's:buntu:nity:g' \
		-i data/ubuntu.session.desktop.in.in \
		-i "${WORKDIR}/debian/data/unity-session.target" || die
	sed -e 's:/usr/lib/gnome-session:/usr/libexec:g' \
		-i data/unity.desktop.in || die

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# 1. Avoid automagic on old upower releases
	# 2. xsltproc is always checked due to man configure
	#    switch, even if USE=-doc
	# 3. Disable old gconf support as other distributions did long time
	#    ago
	gnome2_src_configure \
		--disable-deprecation-flags \
		--disable-gconf \
		--enable-session-selector \
		$(use_enable doc docbook-docs) \
		$(use_enable ipv6) \
		$(use_enable systemd) \
		$(use_enable !systemd consolekit) \
		UPOWER_CFLAGS="" \
		UPOWER_LIBS=""
		# gnome-session-selector pre-generated man page is missing
		#$(usex !doc XSLTPROC=$(type -P true))
}

src_install() {
	gnome2_src_install

	dodir /etc/X11/Sessions
	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/Gnome"

	insinto /usr/share/applications
	newins "${FILESDIR}/defaults.list-r3" gnome-mimeapps.list

	dodir /etc/X11/xinit/xinitrc.d/
	exeinto /etc/X11/xinit/xinitrc.d/
	newexe "${FILESDIR}/15-xdg-data-gnome-r1" 15-xdg-data-gnome

	# This should be done here as discussed in bug #270852
	newexe "${FILESDIR}/10-user-dirs-update-gnome-r1" 10-user-dirs-update-gnome

	# Set XCURSOR_THEME from current dconf setting instead of installing
	# default cursor symlink globally and affecting other DEs (bug #543488)
	# https://bugzilla.gnome.org/show_bug.cgi?id=711703
	newexe "${FILESDIR}/90-xcursor-theme-gnome" 90-xcursor-theme-gnome

#-----------------------------------------------------------------------------------#

	# 'startx' visible via the XSESSION variable #
	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}/unity.xsession" unity

	# Set Unity XDG desktop session variables #
	exeinto /etc/X11/xinit/xinitrc.d
	newexe "${FILESDIR}/15-xdg-data-unity" 15-xdg-data-unity

	# Set ubuntu naming to unity (this is important for XSESSION to DESKTOP_SESSION mapping when using 'startx') #
	mv "${ED}usr/share/gnome-session/sessions/ubuntu.session" "${ED}usr/share/gnome-session/sessions/unity.session"

	# Enables and fills $DESKTOP_SESSION variable for sessions started using 'startx'
	exeinto /etc/X11/xinit/xinitrc.d/
	newexe "${FILESDIR}/05-unity-desktop-session" 05-unity-desktop-session

	# Start gnome-session using upstart #
	insinto /usr/share/upstart/sessions
	newins "${WORKDIR}/debian/gnome-session-bin.user-session.upstart" gnome-session.conf

	# Start gnome-session using systemd #
	exeinto /usr/libexec
	doexe "${WORKDIR}/debian/data/run-systemd-session"

	# Install systemd unit files to enable starting desktop sessions via systemd #
	systemd_douserunit "${WORKDIR}/debian/data/gnome-session.service"
	systemd_douserunit "${WORKDIR}/debian/data/unity-session.target"

	insinto /etc/lightdm/lightdm.conf.d
	doins "${WORKDIR}/debian/data/50-unity.conf"

	insinto /usr/share/upstart/systemd-session/upstart
	doins "${WORKDIR}/debian/data/gnome-session.override"

	if use wayland; then
		sed -e 's:^Exec=gnome-session:Exec=gnome-session --session=gnome:g' \
			-e 's:TryExec=gnome-session:TryExec=gnome-shell:g' \
				-i "${ED}usr/share/xsessions/gnome-xorg.desktop"
		rm "${ED}usr/share/xsessions/gnome.desktop"
	else
		rm "${ED}usr/share/xsessions/gnome-xorg.desktop"
		rm "${ED}usr/share/wayland-sessions/gnome.desktop"
	fi

	# Remove Ubuntu only session files #
	rm "${ED}usr/share/wayland-sessions/ubuntu.desktop"
	rm "${ED}usr/share/xsessions/ubuntu-xorg.desktop"
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version gnome-base/gdm && ! has_version x11-misc/sddm; then
		ewarn "If you use a custom .xinitrc for your X session,"
		ewarn "make sure that the commands in the xinitrc.d scripts are run."
	fi

	ubuntu-versionator_pkg_postinst
}
