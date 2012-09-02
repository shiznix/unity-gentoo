EAPI=4

inherit base eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu1"
URELEASE="precise"
MY_P="${P/files-/files_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Application lens for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/vala:0.14[vapigen]
	unity-base/unity
	unity-base/unity-lens-applications"

src_configure() {
	export VALAC=$(type -P valac-0.14)
	export VALA_API_GEN=$(type -p vapigen-0.14)
	econf
}
