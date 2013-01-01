EAPI=4
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools base eutils gnome2 multilib toolchain-funcs user

# Prefixing version with 99. so as not to break the overlay with upgrades in the main tree #
MY_PV="${PV/99./}"
MY_P="${PN}_${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/g/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"

DESCRIPTION="Fork of bluez-gnome focused on integration with GNOME, patched for the Unity desktop"
HOMEPAGE="http://live.gnome.org/GnomeBluetooth"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1+"
SLOT="2"
IUSE="doc +introspection sendto"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

COMMON_DEPEND=">=dev-libs/glib-2.29.90:2
	>=x11-libs/gtk+-99.2.91.3:3[introspection?]
	>=x11-libs/libnotify-0.7.0
	sys-fs/udev

	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	sendto? ( >=gnome-extra/nautilus-sendto-2.91 )"
RDEPEND="${COMMON_DEPEND}
	>=net-wireless/bluez-4.34
	app-mobilephone/obexd
	x11-themes/gnome-icon-theme-symbolic"
DEPEND="${COMMON_DEPEND}
	!net-wireless/bluez-gnome
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxml2:2
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
	[[ ${PV} != 9999 ]] && G2CONF="${G2CONF} ITSTOOL=$(type -P true)"
	DOCS="AUTHORS README NEWS ChangeLog"

	enewgroup plugdev
}

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
	eautoreconf

	# https://bugzilla.gnome.org/show_bug.cgi?id=685002
	epatch "${FILESDIR}/${PN}-3.6.0-desktop-files.patch"

	# Have bluetooth-applet start in a Unity session #
	sed -e 's:OnlyShowIn=GNOME;:OnlyShowIn=GNOME;Unity;:' \
		-i applet/bluetooth-applet.desktop.in.in || die

	# Regenerate gdbus-codegen files to allow using any glib version; bug #436236
	if [[ ${PV} != 9999 ]]; then
		rm -v lib/bluetooth-client-glue.{c,h} || die
	fi
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install

	local udevdir="$($(tc-getPKG_CONFIG) --variable=udevdir udev)"
	insinto "${udevdir}"/rules.d
	doins "${FILESDIR}"/80-rfkill.rules
}

pkg_postinst() {
	gnome2_pkg_postinst
	# Notify about old libraries that might still be around
	preserve_old_lib_notify /usr/$(get_libdir)/libgnome-bluetooth.so.7

	elog "Don't forget to add yourself to the plugdev group "
	elog "if you want to be able to control bluetooth transmitter."
}
