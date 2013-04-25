EAPI=5
GNOME2_LA_PUNT="yes"

inherit autotools eutils flag-o-matic gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/h/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.04.03"

DESCRIPTION="Backend for the Unity HUD"
HOMEPAGE="https://launchpad.net/hud"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	unity-base/bamf:="
DEPEND="${RDEPEND}
	dev-db/sqlite:3
	>=dev-libs/glib-2.35.4
	dev-perl/XML-Parser
	gnome-base/dconf
	x11-libs/gtk+:3"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	epatch "${FILESDIR}/${PN}_strlen-fix.diff"
	eautoreconf
}
