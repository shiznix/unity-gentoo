EAPI=4

inherit base eutils autotools gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libu/${PN}"
UVER="0ubuntu3.2"
URELEASE="quantal-updates"
MY_P="${P/webapps-/webapps_}"

DESCRIPTION="Webapps integration with the Unity desktop"
HOMEPAGE="https://launchpad.net/libunity-webapps"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="app-admin/packagekit-gtk
	app-misc/geoclue
	dev-db/sqlite:3
	>=dev-libs/glib-2.32.3
	dev-libs/libdbusmenu
	dev-libs/json-glib
	dev-libs/libindicate[gtk]
	dev-libs/libunity
	net-libs/libsoup
	net-libs/telepathy-glib
	>=x11-libs/gtk+-99.3.6.0:3
	unity-base/indicator-messages
	x11-libs/libnotify
	x11-libs/libwnck:3"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare

	# Fix spelling mistakes #
	sed -e 's:flavor:flavour:g' \
		-i configure.ac

	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--libexecdir=/usr/lib/libunity-webapps
}

pkg_postinst() {
	elog "Unity webapps will only currently work if your default browser is set to Firefox"
	elog "Chromium support is being worked on"
}
