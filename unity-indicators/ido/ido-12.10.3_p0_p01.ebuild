EAPI=4
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.03.01"

DESCRIPTION="Widgets and other objects used for indicators by the Unity desktop"
HOMEPAGE="https://launchpad.net/ido"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/vala:0.18[vapigen]
	x11-libs/gtk+:3"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eautoreconf
	export VALAC=$(type -P valac-0.18)
	export VALA_API_GEN=$(type -p vapigen-0.18)
}
