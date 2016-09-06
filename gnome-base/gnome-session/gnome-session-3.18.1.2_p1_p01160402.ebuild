# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="yes"

URELEASE="xenial-updates"
inherit autotools base eutils gnome2 ubuntu-versionator

MY_P="${PN}_${PV}"
S="${WORKDIR}/${PN}-${PV}"

UURL="mirror://unity/pool/main/g/${PN}"

DESCRIPTION="Gnome session manager patched for the Unity desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-session"
SRC_URI="http://ftp.gnome.org/pub/gnome/sources/${PN}/3.18/${PN}-${PV}.tar.xz
	${UURL}/${MY_P}-${UVER}${UVER_PREFIX}.debian.tar.xz"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc elibc_FreeBSD ipv6 systemd"
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

	virtual/opengl
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
	gnome-base/gnome-settings-daemon
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	>=x11-themes/gnome-themes-standard-2.91.92
	sys-apps/dbus[X]
	!systemd? (
		sys-auth/consolekit
		>=dev-libs/dbus-glib-0.76
	)
"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=sys-devel/gettext-0.10.40
	dev-libs/libxslt
	>=dev-util/intltool-0.40.6
	virtual/pkgconfig
	!<gnome-base/gdm-2.20.4
	doc? (
		app-text/xmlto
		dev-libs/libxslt )
"
# gnome-common needed for eautoreconf
# gnome-base/gdm does not provide gnome.desktop anymore

src_prepare() {
	ubuntu-versionator_src_prepare

	# Desktop Session is named 'unity' #
	sed -e 's:Ubuntu:Unity:g' \
		-e 's:session=ubuntu:session=unity:g' \
			-i data/ubuntu.desktop.in || die
	sed -e 's:Ubuntu:Unity:g' \
		-i data/ubuntu.session.desktop.in.in || die
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

#-----------------------------------------------------------------------------------#

	# 'startx' visible via the XSESSION variable #
	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}/unity.xsession" unity

	# Set Unity XDG desktop session variables #
	exeinto /etc/X11/xinit/xinitrc.d
	newexe "${FILESDIR}/15-xdg-data-unity" 15-xdg-data-unity

	# Set ubuntu naming to unity (this is important for XSESSION to DESKTOP_SESSION mapping when using 'startx') #
	mv "${ED}usr/share/gnome-session/sessions/ubuntu.session" "${ED}usr/share/gnome-session/sessions/unity.session"
	mv "${ED}usr/share/xsessions/ubuntu.desktop" "${ED}usr/share/xsessions/unity.desktop"

	# Enables and fills $DESKTOP_SESSION variable for sessions started using 'startx'
	exeinto /etc/X11/xinit/xinitrc.d/
	newexe "${FILESDIR}/05-unity-desktop-session" 05-unity-desktop-session

	# Start gnome-session using upstart #
	insinto /usr/share/upstart/sessions
	newins "${WORKDIR}/debian/gnome-session-bin.user-session.upstart" gnome-session.conf
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version gnome-base/gdm && ! has_version kde-base/kdm; then
		ewarn "If you use a custom .xinitrc for your X session,"
		ewarn "make sure that the commands in the xinitrc.d scripts are run."
	fi

	ubuntu-versionator_pkg_postinst
}
