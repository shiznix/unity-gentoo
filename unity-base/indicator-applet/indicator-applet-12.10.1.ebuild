EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/universe/i/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/applet-/applet_}"

DESCRIPTION="Gnome panel indicator for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/libindicator-99.0.5.0:3
	>=x11-libs/gtk+-99.3.4.2
	>=gnome-base/gnome-panel-3.4.1"

src_prepare() {
	# "Only <glib.h> can be included directly." #
	sed -e "s:glib/gtypes.h:glib.h:g" \
		-i src/tomboykeybinder.h
}
