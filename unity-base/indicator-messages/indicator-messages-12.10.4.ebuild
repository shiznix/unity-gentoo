EAPI=4

inherit base eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/messages-/messages_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Indicator that collects messages that need a response used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="!net-im/indicator-messages
	dev-lang/vala:0.14[vapigen]
	dev-libs/libappindicator
	>=dev-libs/libdbusmenu-0.6.1[gtk]
	dev-libs/libindicate-qt"

src_prepare() {
        export VALAC=$(type -P valac-0.14)
        export VALA_API_GEN=$(type -p vapigen-0.14)
}
