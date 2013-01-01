EAPI=4

inherit eutils gnome2

UURL="https://launchpad.net/${PN}/12.10/${PV}/+download"
UVER="0ubuntu3"
URELEASE="quantal"
MY_P="${P/datetime-/datetime_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Indicator for application menus used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/libappindicator-99.12.10.0
	>=dev-libs/libdbusmenu-99.12.10.2[gtk]
	dev-libs/libindicate-qt
	dev-libs/libtimezonemap
	>=gnome-extra/evolution-data-server-3.6
	unity-base/ido"
