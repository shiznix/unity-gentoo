EAPI=4

inherit eutils gnome2 ubuntu-versionator

UURL="https://launchpad.net/${PN}/12.10/${PV}/+download"
URELEASE="quantal"
GNOME2_LA_PUNT="1"

DESCRIPTION="Indicator for application menus used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libappindicator
	dev-libs/libdbusmenu[gtk]
	dev-libs/libindicate-qt
	dev-libs/libtimezonemap
	>=gnome-extra/evolution-data-server-3.6
	unity-base/ido"

src_configure() {
	econf --with-ccpanel
}
