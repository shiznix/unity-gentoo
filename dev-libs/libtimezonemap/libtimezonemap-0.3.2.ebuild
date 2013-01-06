EAPI=4

inherit base eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libt/${PN}"
UVER="build1"
URELEASE="quantal"
MY_P="${P/-/_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="GTK+3 timezone map widget used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/glib:2
	dev-libs/json-glib
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-99.3.6.0"

S="${WORKDIR}/timezonemap"
