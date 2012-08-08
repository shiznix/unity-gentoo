EAPI=4

inherit gnome2 cmake-utils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/c/${PN}"
UVER="0ubuntu10"   
URELEASE="precise"
MY_P="${P/main-/main_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Compiz Window Manager Plugins for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}~bzr19.orig.tar.bz2
	${UURL}/${MY_P}~bzr19-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=gnome-base/librsvg-2.14.0
	virtual/jpeg
	x11-libs/cairo
	=unity-base/compiz-0.9.7.8"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.19
	>=sys-devel/gettext-0.15"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DCOMPIZ_DISABLE_SCHEMAS_INSTALL=ON
		-DCOMPIZ_INSTALL_GCONF_SCHEMA_DIR=/etc/gconf/schemas"
	cmake-utils_src_configure
}
