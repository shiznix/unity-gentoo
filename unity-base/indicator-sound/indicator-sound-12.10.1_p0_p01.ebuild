EAPI=4

inherit base eutils gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
URELEASE="quantal"
GNOME2_LA_PUNT="1"

DESCRIPTION="System sound indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-sound"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/vala:0.14[vapigen]
	dev-libs/libappindicator
	dev-libs/libdbusmenu[gtk]
	dev-libs/libgee:0
	dev-libs/libindicate-qt
	media-sound/pulseaudio
	unity-base/ido"

src_prepare() {
        export VALAC=$(type -P valac-0.14)
        export VALA_API_GEN=$(type -p vapigen-0.14)
}
