EAPI=4
GNOME2_LA_PUNT="yes"

inherit autotools base gnome2 ubuntu-versionator

MY_PN="evolution-indicator"
UURL="http://archive.ubuntu.com/ubuntu/pool/main/e/${MY_PN}"
URELEASE="raring"

DESCRIPTION="Indicator for the Evolution mail client used by the Unity desktop"
HOMEPAGE="https://launchpad.net/evolution-indicator"
SRC_URI="${UURL}/${MY_PN}_${PV}.orig.tar.gz
	${UURL}/${MY_PN}_${PV}-${UVER}.debian.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=dev-libs/glib-2.31.8
	dev-libs/libappindicator
	dev-libs/libdbusmenu[gtk]
	dev-libs/libindicate
	dev-libs/libunity
	gnome-base/gconf
	>=gnome-extra/evolution-data-server-3.6
	>=mail-client/evolution-3.6
	media-libs/libcanberra
	unity-base/indicator-messages
	x11-libs/libnotify"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
	eautoreconf
}

src_configure() {
	econf --disable-static
}
