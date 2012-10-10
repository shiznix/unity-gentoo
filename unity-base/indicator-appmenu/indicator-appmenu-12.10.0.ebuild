EAPI=4

inherit autotools base eutils gnome2

UURL="https://launchpad.net/${PN}/12.10/${PV}/+download"
UVER="0ubuntu1"
URELEASE="quantal"
GNOME2_LA_PUNT="1"

DESCRIPTION="Indicator for application menus used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/vala:0.16[vapigen]
	>=dev-libs/libappindicator-99.12.10.0
	>=dev-libs/libdbusmenu-99.12.10.2[gtk]
	dev-libs/libindicate-qt
	unity-base/bamf
	>=x11-libs/gtk+-3.5.12:3
	x11-libs/libwnck:1
	x11-libs/libwnck:3"

src_prepare() {
	export VALAC=$(type -P valac-0.16)
	export VALA_API_GEN=$(type -p vapigen-0.16)

	epatch "${FILESDIR}/indicator-appmenu_strlen-fix.diff"
}
