EAPI="4"
GCONF_DEBUG="yes"

inherit autotools base eutils gnome2

# Prefixing version with 99. so as not to break the overlay with upgrades in the main tree #
MY_PV="${PV/99./}"
MY_P="${PN}_${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/g/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${MY_P/screensaver-/screensaver_}"

DESCRIPTION="Replaces xscreensaver, integrating with and patched for the Unity desktop"
HOMEPAGE="http://live.gnome.org/GnomeScreensaver"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug doc pam systemd"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND=">=dev-libs/glib-2.25.6:2
	>=x11-libs/gtk+-2.99.3:3
	>=gnome-base/gnome-desktop-3.1.91:3
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	>=gnome-base/libgnomekbd-0.1
	>=dev-libs/dbus-glib-0.71

	sys-apps/dbus
	x11-libs/libxklavier
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/libXxf86misc
	x11-libs/libXxf86vm
	x11-themes/gnome-icon-theme-symbolic

	pam? ( virtual/pam )
	systemd? ( >=sys-apps/systemd-31 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.35
	sys-devel/gettext
	doc? (
		app-text/xmlto
		app-text/docbook-xml-dtd:4.1.2
		app-text/docbook-xml-dtd:4.4 )
	x11-proto/xextproto
	x11-proto/randrproto
	x11-proto/scrnsaverproto
	x11-proto/xf86miscproto"

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	G2CONF="${G2CONF}
		$(use_enable doc docbook-docs)
		$(use_enable pam locking)
		$(use_with systemd)
		--with-mit-ext
		--with-pam-prefix=/etc
		--with-xf86gamma-ext
		--with-kbd-layout-indicator
		--disable-schemas-compile"
	# Do not use --without-console-kit, it would provide no benefit: there is
	# no build-time or run-time check for consolekit, $PN merely listens to
	# consolekit's messages over dbus.
	# xscreensaver and custom screensaver capability removed
	# poke and inhibit commands were also removed, bug 579430
}

src_prepare() {
	# Disable selected patches #
	sed \
		`# Disable lightdm patches` \
			-e 's:26_lightdm_greeter_on_lock:^#26_lightdm_greeter_on_lock:g' \
			-e 's:27_lightdm_switch_user:^#27_lightdm_switch_user:g' \
		-i "${WORKDIR}/debian/patches/series"

	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
	eautoreconf

	epatch_user
	# Regenerate marshaling code for <glib-2.31 compat
	rm -v src/gs-marshal.{c,h} || die
	gnome2_src_prepare
}
