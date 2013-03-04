EAPI=4

inherit base gnome2 cmake-utils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/d/${PN}"
URELEASE="quantal"
GNOME2_LA_PUNT="1"

DESCRIPTION="Dconf Qt bindings for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2
        ${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=dev-libs/glib-2.32.3
	dev-qt/qtcore:4
	dev-qt/qtdeclarative:4
	gnome-base/dconf"
DEPEND="${RDEPEND}"

S="${WORKDIR}/lib${PN}-0.0.0"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DIMPORT_INSTALL_DIR=lib/qt/imports/QConf \
		-DCMAKE_BUILD_TYPE=Release"
	cmake-utils_src_configure
}
