EAPI=5
PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"

inherit autotools eutils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.04.15"

DESCRIPTION="Video lens for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-video"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="!unity-lenses/unity-scope-video-remote
	dev-libs/dee:=
	dev-libs/libunity:="
DEPEND="dev-lang/vala:0.18[vapigen]
	dev-libs/dee
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee
	dev-libs/libunity
	dev-libs/libzeitgeist
	net-libs/libsoup
	unity-base/unity
	unity-lenses/unity-lens-music"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eautoreconf
	export VALAC=$(type -P valac-0.18)
	export VALA_API_GEN=$(type -p vapigen-0.18)
}
