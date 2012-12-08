EAPI=4

inherit base eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/t/${PN}"
UVER="0ubuntu3"
URELEASE="quantal"
MY_P="${P/indicator-/indicator_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Desktop service to integrate Telepathy with the messaging menu used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/vala:0.14[vapigen]
	dev-libs/libappindicator
	>=dev-libs/libdbusmenu-0.6.1[gtk]
	dev-libs/libindicate-qt
	dev-libs/libunity
	net-libs/telepathy-glib
	unity-base/indicator-messages"

src_prepare() {
        export VALAC=$(type -P valac-0.14)
        export VALA_API_GEN=$(type -p vapigen-0.14)
}
