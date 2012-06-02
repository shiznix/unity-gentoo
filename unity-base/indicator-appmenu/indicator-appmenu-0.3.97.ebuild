EAPI=4

inherit base eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/appmenu-/appmenu_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Indicator for application menus used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/libappindicator-0.4.92
	>=dev-libs/libdbusmenu-0.6.1[gtk]
	dev-libs/libindicate-qt"

src_prepare() {
	epatch "${FILESDIR}/indicator-appmenu_strlen-fix.diff"
}
