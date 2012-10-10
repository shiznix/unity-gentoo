EAPI=4

inherit base eutils gnome2

UURL="https://launchpad.net/${PN}/12.10/${PV}/+download"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/datetime-/datetime_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Indicator for application menus used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/libappindicator
	>=dev-libs/libdbusmenu-0.6.1[gtk]
	dev-libs/libindicate-qt
	dev-libs/libtimezonemap
	>=gnome-extra/evolution-data-server-3.2
	<gnome-extra/evolution-data-server-3.5"

src_prepare() {
	PATCHES+=( "${FILESDIR}/0001_Revert_port_to_EDS_3.6_API.patch" )
	base_src_prepare
}
