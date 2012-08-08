EAPI=4

inherit base gnome2 cmake-utils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libc/${PN}"
UVER="0ubuntu6"
URELEASE="precise"
MY_PV="0.9.7.0"	# Tarball version is 0.9.7.0 but source inside is version 0.9.5.94 ?!
GNOME2_LA_PUNT="1"

DESCRIPTION="Settings library for compiz plugins for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${PN}_${MY_PV}~bzr428.orig.tar.bz2
	${UURL}/${PN}_${MY_PV}~bzr428-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/protobuf
	>=unity-base/compiz-0.9.7.8"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DCOMPIZ_DISABLE_SCHEMAS_INSTALL=ON
		-DCOMPIZ_INSTALL_GCONF_SCHEMA_DIR=/etc/gconf/schemas
		-DCOMPIZ_DESTDIR=${D}"
	cmake-utils_src_configure
}

src_install() {
	insinto "/usr/share/cmake/Modules"
	doins "cmake/FindCompizConfig.cmake" || die "Failed to install FindCompizConfig.cmake"
	pushd ${CMAKE_BUILD_DIR}
	emake install
	popd ${CMAKE_BUILD_DIR}
}
