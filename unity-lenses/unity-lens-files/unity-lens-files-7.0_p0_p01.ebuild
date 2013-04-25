EAPI=5
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
URELEASE="raring"
UVER_PREFIX="~daily13.04.15"

DESCRIPTION="File lens for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-files"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/dee:=
	dev-libs/libunity:="
DEPEND="${RDEPEND}
	dev-lang/vala:0.16[vapigen]
	dev-libs/libgee
	dev-libs/libzeitgeist
	>=gnome-extra/zeitgeist-0.9.12[datahub,dbus,fts]
	unity-base/unity
	unity-lenses/unity-lens-applications"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eautoreconf
}

src_configure() {
	export VALAC=$(type -P valac-0.16)
	export VALA_API_GEN=$(type -p vapigen-0.16)
	econf
}
