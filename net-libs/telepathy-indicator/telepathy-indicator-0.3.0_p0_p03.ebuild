EAPI=4
GNOME2_LA_PUNT="yes"

inherit base eutils gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/t/${PN}"
URELEASE="quantal"

DESCRIPTION="Desktop service to integrate Telepathy with the messaging menu used by the Unity desktop"
HOMEPAGE="https://launchpad.net/telepathy-indicator"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/vala:0.14[vapigen]
	dev-libs/libappindicator
	dev-libs/libdbusmenu[gtk]
	dev-libs/libindicate-qt
	dev-libs/libunity
	net-libs/telepathy-glib
	unity-base/indicator-messages"

src_prepare() {
        export VALAC=$(type -P valac-0.14)
        export VALA_API_GEN=$(type -p vapigen-0.14)
}
