EAPI=4

inherit autotools base eutils gnome2 virtualx

# Renaming version to 99.3.4.2 so as not to break the overlay with gnome-base/gnome-settings-daemon upgrades in the main tree #
MY_PV="${PV/99./}"
MY_P="${PN}_${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/g/${PN}"
UVER="0ubuntu2"   
URELEASE="quantal"
MY_P="${MY_P/daemon-/daemon_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Gnome Settings Daemon patched for the Unity desktop"
HOMEPAGE="http://www.gnome.org"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
        ${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="+colord +cups debug packagekit policykit smartcard systemd +udev"

# colord-0.1.13 needed to avoid polkit errors in CreateProfile and CreateDevice
COMMON_DEPEND="
	>=dev-libs/glib-2.31.0:2
	>=dev-libs/libwacom-0.3
	>=x11-libs/gtk+-99.3.4.2:3
	>=gnome-base/libgnomekbd-2.91.1
	>=gnome-base/gnome-desktop-3.3.92:3
	>=gnome-base/gsettings-desktop-schemas-3.3.0
	media-fonts/cantarell
	media-libs/fontconfig
	>=media-libs/lcms-2.2:2
	media-libs/libcanberra[gtk3]
	>=media-sound/pulseaudio-0.9.16
	>=sys-power/upower-0.9.11
	>=x11-drivers/xf86-input-wacom-0.14.0
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/libnotify-0.7.3
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXext
	=x11-libs/libXfixes-5.0-r9999
	x11-libs/libXtst
	x11-libs/libXxf86misc
	>=x11-libs/libxklavier-5.0
	>=x11-misc/colord-0.1.13
	cups? ( >=net-print/cups-1.4[dbus] )
	packagekit? (
		sys-fs/udev[gudev]
		>=app-admin/packagekit-base-0.6.12 )
	smartcard? (
		sys-fs/udev[gudev]
		>=dev-libs/nss-3.11.2 )
	systemd? ( >=sys-apps/systemd-31 )
	udev? ( sys-fs/udev[gudev] )"
# Themes needed by g-s-d, gnome-shell, gtk+:3 apps to work properly
# <gnome-power-manager-3.1.3 has file collisions with g-s-d-3.1.x
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	>=x11-themes/gnome-themes-standard-2.91
	>=x11-themes/gnome-icon-theme-2.91
	>=x11-themes/gnome-icon-theme-symbolic-2.91
	!<gnome-base/gnome-control-center-2.22
	!<gnome-extra/gnome-color-manager-3.1.1
	!<gnome-extra/gnome-power-manager-3.1.3

	!systemd? ( sys-auth/consolekit )"
# xproto-7.0.15 needed for power plugin
DEPEND="${COMMON_DEPEND}
	cups? ( sys-apps/sed )
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	x11-proto/inputproto
	x11-proto/kbproto
	x11-proto/xf86miscproto
	>=x11-proto/xproto-7.0.15"

pkg_setup() {
	# README is empty
	DOCS="AUTHORS NEWS ChangeLog MAINTAINERS"
	G2CONF="${G2CONF}
		--disable-static
		--disable-schemas-compile
		--enable-gconf-bridge
		$(use_enable cups)
		$(use_enable debug)
		$(use_enable debug more-warnings)
		$(use_enable packagekit)
		$(use_enable smartcard smartcard-support)
		$(use_enable systemd)
		$(use_enable udev gudev)"
}

src_prepare() {
        for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
                PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
        done
        base_src_prepare
	eautoreconf
	gnome2_src_prepare
}

src_test() {
	Xemake check
}

src_install() {
	gnome2_src_install

	echo 'GSETTINGS_BACKEND="dconf"' >> 51gsettings-dconf
	doenvd 51gsettings-dconf
}
