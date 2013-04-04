EAPI=4

inherit autotools base eutils gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.02.19"
GNOME2_LA_PUNT="1"

DESCRIPTION="System bluetooth indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-bluetooth"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/vala:0.16[vapigen]
	dev-libs/glib
	dev-libs/libappindicator
	dev-libs/libdbusmenu[gtk]
	dev-libs/libindicator
	gnome-base/dconf
	net-wireless/gnome-bluetooth
	unity-base/ido
	x11-libs/gtk+:3"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
        export VALAC=$(type -P valac-0.16)
        export VALA_API_GEN=$(type -p vapigen-0.16)
	eautoreconf
}
