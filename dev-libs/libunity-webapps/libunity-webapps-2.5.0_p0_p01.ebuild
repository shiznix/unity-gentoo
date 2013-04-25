EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libu/${PN}"
URELEASE="raring"
UVER_PREFIX="~daily13.03.18"

DESCRIPTION="Webapps integration with the Unity desktop"
HOMEPAGE="https://launchpad.net/libunity-webapps"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0/0.0.0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	dev-libs/libunity:="
DEPEND="${RDEPEND}
	app-admin/packagekit-gtk
	app-misc/geoclue
	dev-db/sqlite:3
	>=dev-libs/glib-2.32.3:2
	dev-libs/gobject-introspection
	dev-libs/json-glib
	dev-libs/libindicate[gtk]
	dev-util/intltool
	net-libs/libsoup
	net-libs/telepathy-glib
	x11-libs/gtk+:3
	unity-indicators/indicator-messages
	x11-libs/libnotify
	x11-libs/libwnck:3"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--libexecdir=/usr/lib/libunity-webapps
}

src_install() {
	gnome2_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf ${ED}usr/share/locale	
}

pkg_postinst() {
	elog
	elog "Unity webapps will only currently work if your default browser"
	elog "is set to either Firefox or Chromium"
	elog
}
