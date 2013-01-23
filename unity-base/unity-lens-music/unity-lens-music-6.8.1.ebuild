EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/music-/music_}"

DESCRIPTION="Application lens for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/vala:0.16[vapigen]
	dev-libs/libzeitgeist
	gnome-base/gnome-menus:3
	>=media-libs/gstreamer-0.10.36:0.10
	>=media-libs/gst-plugins-base-0.10.36:0.10
	unity-base/rhythmbox-ubuntuone
	unity-base/unity"

PATCHES=( "${WORKDIR}/${MY_P}-${UVER}.diff" )

src_configure() {
	export VALAC=$(type -P valac-0.16)
	export VALA_API_GEN=$(type -p vapigen-0.16)
	econf
}
