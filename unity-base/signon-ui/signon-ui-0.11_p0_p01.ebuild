EAPI=4

inherit qt4-r2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/s/${PN}"
URELEASE="quantal"

DESCRIPTION="Single Sign On framework for the Unity desktop"
HOMEPAGE="http://code.google.com/p/accounts-sso/"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libaccounts-qt
	net-libs/libproxy
	unity-base/signon
	x11-libs/qt-core
	x11-libs/qt-dbus
	x11-libs/qt-gui
	x11-libs/qt-sql
	x11-libs/qt-xmlpatterns
	x11-libs/qt-webkit
	x11-libs/libnotify"
