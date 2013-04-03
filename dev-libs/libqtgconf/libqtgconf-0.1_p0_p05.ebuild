EAPI=4

inherit gnome2 cmake-utils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libq/${PN}"
URELEASE="raring"
GNOME2_LA_PUNT="1"

DESCRIPTION="Qt binding and QML plugin for GConf for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtdeclarative:4
	gnome-base/gconf"
DEPEND="${RDEPEND}"

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_PREFIX=/usr
		-DIMPORT_INSTALL_DIR=lib/qt/imports/gconf
		-DCMAKE_BUILD_TYPE=Release"
	cmake-utils_src_configure
}
