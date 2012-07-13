EAPI="4"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2

# Prefixing version with 99. so as not to break the overlay with upgrades in the main tree #
MY_PV="${PV/99./}"
MY_P="${PN}_${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/g/${PN}"
UVER="0ubuntu8"
URELEASE="precise"
MY_P="${MY_P/session-/session_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Gnome session manager patched for the Unity desktop"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc elibc_FreeBSD ipv6 systemd"

# x11-misc/xdg-user-dirs{,-gtk} are needed to create the various XDG_*_DIRs, and
# create .config/user-dirs.dirs which is read by glib to get G_USER_DIRECTORY_*
# xdg-user-dirs-update is run during login (see 10-user-dirs-update-gnome below).
# gdk-pixbuf used in the inhibit dialog
COMMON_DEPEND=">=dev-libs/glib-2.28.0:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.90.7:3
	>=dev-libs/json-glib-0.10
	>=dev-libs/dbus-glib-0.76
	>=gnome-base/gconf-2:2
	>=sys-power/upower-0.9.0
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
	x11-apps/xdpyinfo"
# Pure-runtime deps from the session files should *NOT* be added here
# Otherwise, things like gdm pull in gnome-shell
# gnome-themes-standard is needed for the failwhale dialog themeing
# sys-apps/dbus[X] is needed for session management
RDEPEND="${COMMON_DEPEND}
	gnome-base/gnome-settings-daemon
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	>=x11-themes/gnome-themes-standard-2.91.92
	sys-apps/dbus[X]
	systemd? ( >=sys-apps/systemd-38 )
	!systemd? ( sys-auth/consolekit )"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=sys-devel/gettext-0.10.40
	>=dev-util/intltool-0.40.6
	virtual/pkgconfig
	!<gnome-base/gdm-2.20.4
	doc? (
		app-text/xmlto
		dev-libs/libxslt )"
# gnome-common needed for eautoreconf
# gnome-base/gdm does not provide gnome.desktop anymore

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-deprecation-flags
		--disable-schemas-compile
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		$(use_enable doc docbook-docs)
		$(use_enable ipv6)
		$(use_enable systemd)"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	# Disable this patch as totally breaks gnome-session #
	sed -e 's:^96_no_catch_sigsegv:#96_no_catch_sigsegv:g' \
		-i "${WORKDIR}/debian/patches/series"

	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		epatch -p1 "${WORKDIR}/debian/patches/${patch}" || die;
	done
	eautoreconf
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install

	dodir /etc/X11/Sessions
	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/Gnome"

	dodir /usr/share/gnome/applications/
	insinto /usr/share/gnome/applications/
	doins "${FILESDIR}/defaults.list"

	dodir /etc/X11/xinit/xinitrc.d/
	exeinto /etc/X11/xinit/xinitrc.d/
	newexe "${FILESDIR}/15-xdg-data-gnome-r1" 15-xdg-data-gnome

	# This should be done here as discussed in bug #270852
	newexe "${FILESDIR}/10-user-dirs-update-gnome-r1" 10-user-dirs-update-gnome
#-----------------------------------------------------------------------------------#
	rm "${D}usr/share/gnome-session/sessions/ubuntu.session"
	rm "${D}usr/share/gnome-session/sessions/ubuntu-2d.session"
	rm "${D}/usr/share/gnome-session/sessions/gnome-classic.session"
	rm "${D}/usr/share/gnome-session/sessions/gnome-fallback.session"
	rm "${D}/usr/share/xsessions/ubuntu.desktop"
	rm "${D}/usr/share/xsessions/ubuntu-2d.desktop"
	rm "${D}/usr/share/xsessions/gnome-classic.desktop"
	rm "${D}/usr/share/xsessions/gnome-fallback.desktop"

	# XDM visible #
	insinto /usr/share/xsessions
		doins "${FILESDIR}/unity.desktop"
		doins "${FILESDIR}/unity-2d.desktop"
		doins "${FILESDIR}/gnome-classic.desktop"
		doins "${FILESDIR}/gnome-fallback.desktop"

	# 'gnome-session' visible as executed by --session=... #
	insinto /usr/share/gnome-session/sessions
		doins "${FILESDIR}/unity.session"
		doins "${FILESDIR}/unity-2d.session"
		doins "${FILESDIR}/gnome-classic.session"
		doins "${FILESDIR}/gnome-fallback.session"

	# 'startx' visible via the XSESSION variable #
	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}/unity.xsession" unity

	# Set Unity XDG desktop session variables #
	exeinto /etc/X11/xinit/xinitrc.d
	newexe "${FILESDIR}/15-xdg-data-unity" "15-xdg-data-unity"
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version gnome-base/gdm && ! has_version kde-base/kdm; then
		ewarn "If you use a custom .xinitrc for your X session,"
		ewarn "make sure that the commands in the xinitrc.d scripts are run."
	fi
}
