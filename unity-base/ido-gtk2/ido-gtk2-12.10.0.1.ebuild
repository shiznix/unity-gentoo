EAPI=4

inherit base eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/universe/i/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/gtk2-/gtk2_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Widgets and other objects used for indicators by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=x11-libs/gtk+-99.2.24.10:2"

S="${WORKDIR}/ido-${PV}"
