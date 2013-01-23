EAPI=4

inherit base eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/power-/power_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Indicator showing power state used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=dev-libs/glib-2.34
	dev-libs/libappindicator
	>=dev-libs/libdbusmenu-99.12.10.2[gtk]
	dev-libs/libindicate-qt
	sys-power/upower"
