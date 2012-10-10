EAPI=4

inherit qt4-r2

DESCRIPTION="Multitouch gesture recognizer"
HOMEPAGE="https://code.google.com/p/touchegg"
SRC_URI="http://touchegg.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="unity-base/geis
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXtst
	x11-libs/qt-core:4
	x11-libs/qt-gui:4"
DEPEND="${RDEPEND}"

src_prepare() {
	# Use newer GEIS libs #
	sed -e 's:utouch-geis:geis:g' \
		-i touchegg.pro
}
