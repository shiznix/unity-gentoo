EAPI=5
VALA_MIN_API_VERSION="0.20"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils ubuntu-versionator vala

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
	dev-libs/dee
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee
	dev-libs/libunity
	gnome-base/gnome-menus:3
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	|| ( ( net-libs/libsoup
		net-libs/libsoup-gnome )
		>net-libs/libsoup-2.42 )
	net-libs/liboauth
	sys-libs/tdb
	unity-base/unity
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}
