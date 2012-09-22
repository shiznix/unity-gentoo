EAPI=4

inherit autotools base eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
UVER="0ubuntu1"
URELEASE="precise"
MY_P="${P/appmenu-/appmenu_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Indicator for application menus used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/vala:0.16[vapigen]
	dev-libs/libappindicator
	>=dev-libs/libdbusmenu-0.6.1[gtk]
	dev-libs/libindicate-qt
	unity-base/bamf
	x11-libs/libwnck:1
	x11-libs/libwnck:3"

src_prepare() {
	export VALAC=$(type -P valac-0.16)
	export VALA_API_GEN=$(type -p vapigen-0.16)

	epatch "${FILESDIR}/indicator-appmenu_strlen-fix.diff"
}
