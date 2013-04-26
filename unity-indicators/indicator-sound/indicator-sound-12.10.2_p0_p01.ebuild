EAPI=5
GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.20"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils gnome2 ubuntu-versionator vala

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.04.12"

DESCRIPTION="System sound indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-sound"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	unity-base/bamf:=
	unity-indicators/ido:="
DEPEND="${RDEPEND}
	dev-libs/libappindicator
	dev-libs/libgee:0
	dev-libs/libindicate-qt
	media-sound/pulseaudio"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}
