EAPI=4

inherit autotools base eutils gnome2

# Prefixing version with 99. so as not to break the overlay with upgrades in the main tree #
MY_PN="network-manager-applet"
MY_PV="${PV/99./}"
MY_P="${MY_PN}_${MY_PV}"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/n/${MY_PN}"
UVER="0ubuntu2"
URELEASE="precise"
MY_P="${MY_P/applet-/applet_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="GNOME applet for NetworkManager patched for the Unity desktop"
HOMEPAGE="http://projects.gnome.org/NetworkManager/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="bluetooth"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=dev-libs/glib-99.2.32.1:2
	>=dev-libs/dbus-glib-0.88
	>=dev-libs/libappindicator-0.4.92
	>=gnome-base/gconf-2.20:2
	>=gnome-base/gnome-keyring-2.20
	>=sys-apps/dbus-1.4.1
	>=sys-auth/polkit-0.96-r1
	>=x11-libs/gtk+-99.3.4.2:3
	>=x11-libs/libnotify-0.7.0
	app-text/iso-codes
	>=net-misc/networkmanager-0.9.4
	net-misc/mobile-broadband-provider-info
	bluetooth? ( >=net-wireless/gnome-bluetooth-99.3.2.2 )
	virtual/freedesktop-icon-theme"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--with-gtkver=3
		--disable-more-warnings
		--disable-static
		--localstatedir=/var
		--enable-appindicator
		$(use_with bluetooth)"
}

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare

	eautoreconf

	sed -e "s:-Werror::g" \
		-i "configure" || die
}

src_configure() {
	econf \
		--enable-indicator
}

src_install() {
	DESTDIR="${D}" emake install

	insinto /usr/share/icons/hicolor/22x22/apps
	doins "${WORKDIR}/debian/icons/22/*.png"
	dosym nm-signal-00.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-none.png
	dosym nm-signal-00-secure.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-none-secure.png
	dosym nm-signal-25.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-low.png
	dosym nm-signal-25-secure.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-low-secure.png
	dosym nm-signal-50.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-medium.png
	dosym nm-signal-50-secure.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-medium-secure.png
	dosym nm-signal-75.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-high.png
	dosym nm-signal-75-secure.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-high-secure.png
	dosym nm-signal-100.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-full.png
	dosym nm-signal-100-secure.png \
		/usr/share/icons/hicolor/22x22/apps/gsm-3g-full-secure.png
}
