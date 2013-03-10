EAPI=4

inherit eutils autotools ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/r/${PN}"
URELEASE="raring"
GNOME2_LA_PUNT="1"

DESCRIPTION="A service that lists remote logins."
HOMEPAGE="https://launchpad.net/remote-login-service"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgcrypt"

RDEPEND=">=net-misc/networkmanager-0.9.7
	>=net-libs/libsoup-2.40"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# remove 'dbustest1-dev' dependency
	sed -i -e '/^PKG_CHECK_MODULES(TEST, dbustest-1)/d' configure.ac

	eautoreconf
}

src_prepare() {
	epatch "${FILESDIR}/01_clear_servers.patch"
	epatch "${FILESDIR}/glib-deprecated.diff"
}
