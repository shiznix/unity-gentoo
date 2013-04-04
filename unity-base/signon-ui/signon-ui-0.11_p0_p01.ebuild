EAPI=4

inherit qt4-r2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/s/${PN}"
URELEASE="quantal"

DESCRIPTION="Single Sign On framework for the Unity desktop"
HOMEPAGE="https://launchpad.net/signon-ui"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libaccounts-qt
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qtsql:4
	dev-qt/qtxmlpatterns:4
	dev-qt/qtwebkit:4
	net-libs/libproxy
	unity-base/signon
	x11-libs/libnotify"
