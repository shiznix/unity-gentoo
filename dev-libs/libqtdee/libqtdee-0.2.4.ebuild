EAPI=4

inherit gnome2 cmake-utils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libq/${PN}"
UVER="0ubuntu1"
URELEASE="precise"
MY_P="${P/-/_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Qt binding and QML plugin for dee for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-libs/dee
	unity-base/bamf
	>=x11-libs/qt-core-99.4.8.2:4
	>=x11-libs/qt-declarative-99.4.8.2:4"
DEPEND="${RDEPEND}"

PATCHES=( "${WORKDIR}/${MY_P}-${UVER}.diff" )

src_configure() {
	mycmakeargs="${mycmakeargs} \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DIMPORT_INSTALL_DIR=lib/qt/imports/dee \
		-DCMAKE_BUILD_TYPE=Release"
	cmake-utils_src_configure
}
