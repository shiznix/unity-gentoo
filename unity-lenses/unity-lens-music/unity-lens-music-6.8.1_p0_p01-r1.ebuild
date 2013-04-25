EAPI=5

inherit autotools eutils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.04.18~13.04"

DESCRIPTION="Music lens for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-music"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/dee:=
	dev-libs/libunity:=
	unity-base/rhythmbox-ubuntuone"
DEPEND="dev-db/sqlite:3
	dev-lang/vala:0.18[vapigen]
	dev-libs/dee
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee
	dev-libs/libunity
	gnome-base/gnome-menus:3
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	net-libs/libsoup
	net-libs/liboauth
	sys-libs/tdb
	unity-base/unity"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eautoreconf
	export VALAC=$(type -P valac-0.18)
	export VALA_API_GEN=$(type -p vapigen-0.18)
}
