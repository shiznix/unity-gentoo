EAPI=4

inherit qt4-r2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/s/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/ui-/ui_}"

DESCRIPTION="Single Sign On framework for the Unity desktop"
HOMEPAGE="http://code.google.com/p/accounts-sso/"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libaccounts-qt
	x11-libs/qt-core
	x11-libs/qt-dbus
	x11-libs/qt-gui
	x11-libs/qt-sql
	x11-libs/qt-xmlpatterns
	x11-libs/qt-webkit"
