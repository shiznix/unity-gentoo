EAPI=4
GNOME2_LA_PUNT="yes"

inherit gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/universe/i/${PN}"
URELEASE="raring"

DESCRIPTION="Graphical system load indicator for CPU, ram, etc. used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-multiload"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=dev-libs/glib-2.28.0
	dev-libs/libappindicator
	dev-libs/libdbusmenu[gtk]
	dev-libs/libindicate
	gnome-base/dconf
	gnome-base/libgtop
	x11-libs/cairo
	x11-libs/gtk+:3"
