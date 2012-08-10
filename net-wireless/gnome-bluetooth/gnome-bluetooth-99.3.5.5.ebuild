EAPI=4

inherit base gnome2 multilib

# Prefixing version with 99. so as not to break the overlay with upgrades in the main tree #
MY_PV="${PV/99./}"
MY_P="${PN}_${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/g/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${MY_P/bluetooth-/bluetooth_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Fork of bluez-gnome focused on integration with GNOME, patched for the Unity desktop"
HOMEPAGE="http://live.gnome.org/GnomeBluetooth"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2"
IUSE="doc +introspection sendto"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND=">=dev-libs/glib-2.29.90:2
	>=x11-libs/gtk+-99.3.4.2:3[introspection?]
	>=x11-libs/libnotify-0.7.0
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	sendto? ( >=gnome-extra/nautilus-sendto-2.91 )"
RDEPEND="${COMMON_DEPEND}
	>=net-wireless/bluez-4.34
	>=net-wireless/blueman-1.23-r2
	app-mobilephone/obexd
	sys-fs/udev
	x11-themes/gnome-icon-theme-symbolic"
DEPEND="${COMMON_DEPEND}
	!net-wireless/bluez-gnome
	app-text/docbook-xml-dtd:4.1.2
	app-text/gnome-doc-utils
	app-text/scrollkeeper
	dev-libs/libxml2
	>=dev-util/intltool-0.40.0
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	x11-libs/libX11
	x11-libs/libXi
	x11-proto/xproto
	doc? ( >=dev-util/gtk-doc-1.9 )"
# eautoreconf needs:
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am

pkg_setup() {
	# FIXME: Add geoclue support
	G2CONF="${G2CONF}
		$(use_enable introspection)
		$(use_enable sendto nautilus-sendto)
		--enable-documentation
		--disable-maintainer-mode
		--disable-desktop-update
		--disable-icon-update
		--disable-schemas-compile
		--disable-static"
	DOCS="AUTHORS README NEWS ChangeLog"

	enewgroup plugdev
}

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
}

src_install() {
	gnome2_src_install

	insinto /$(get_libdir)/udev/rules.d
	doins "${FILESDIR}"/80-rfkill.rules

	insinto /etc/xdg/autostart
	doins "${WORKDIR}/debian/bluetooth-applet-unity.desktop"
}

pkg_postinst() {
	gnome2_pkg_postinst
	# Notify about old libraries that might still be around
	preserve_old_lib_notify /usr/$(get_libdir)/libgnome-bluetooth.so.7

	elog "Don't forget to add yourself to the plugdev group "
	elog "if you want to be able to control bluetooth transmitter."
}
