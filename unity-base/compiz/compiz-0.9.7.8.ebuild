EAPI=4

inherit base gnome2 cmake-utils eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/c/${PN}"
UVER="0ubuntu1.2"
URELEASE="precise-updates"
MY_P="${P/-/_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Compiz Fusion OpenGL window and compositing manager patched for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMONDEPEND="!x11-wm/compiz
	!x11-libs/compiz-bcop
	!x11-libs/compiz-plugins-main
	>=dev-libs/boost-1.34.0
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/libxslt
	>=gnome-base/librsvg-2.14.0:2
	media-libs/libpng
	<=media-libs/mesa-8.0.4
	=x11-base/xorg-server-1.12.3-r9999
	>=x11-libs/cairo-1.0
	>=x11-libs/gtk+-99.3.4.2
	x11-libs/pango
	x11-libs/libwnck:1
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	=x11-libs/libXfixes-5.0-r9999
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXinerama
	x11-libs/libICE
	x11-libs/libSM
	>=x11-libs/startup-notification-0.7"

DEPEND="${COMMONDEPEND}
	dev-util/pkgconfig
	x11-proto/damageproto
	x11-proto/xineramaproto"

RDEPEND="${COMMONDEPEND}
	x11-apps/mesa-progs
	x11-apps/xvinfo"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
        	PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare

	sed -e "s:COMPIZ_CORE_INCLUDE_DIR \${includedir}/compiz/core:COMPIZ_CORE_INCLUDE_DIR ${D}usr/include/compiz/core:g" \
		-i cmake/CompizDefaults.cmake
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DCOMPIZ_BUILD_WITH_RPATH=FALSE
		-DCOMPIZ_DISABLE_SCHEMAS_INSTALL=ON
		-DCOMPIZ_INSTALL_GCONF_SCHEMA_DIR=/etc/gconf/schemas
		-DCOMPIZ_PACKAGING_ENABLED=ON
		-DCOMPIZ_DISABLE_PLUGIN_KDE=ON
		-DUSE_KDE4=OFF
		-DUSE_GNOME=OFF
		-DUSE_GTK=ON
		-DUSE_GSETTINGS=OFF
		-DCOMPIZ_DISABLE_GS_SCHEMAS_INSTALL=ON
		-DCOMPIZ_BUILD_TESTING=OFF
		-DCOMPIZ_DESTDIR="${D}"
		-DCOMPIZ_DEFAULT_PLUGINS="core,composite,opengl,compiztoolbox,decor,vpswitch,\
snap,mousepoll,resize,place,move,wall,grid,regex,imgpng,session,gnomecompat,animation,fade,\
unitymtgrabhandles,workarounds,scale,expo,ezoom,unityshell""	# Default set of plugins taken from unity.ini #
#		-DCOMPIZ_DEFAULT_PLUGINS="ccp"
	cmake-utils_src_configure
}

src_install() {
	pushd ${CMAKE_BUILD_DIR}
	dodir /usr/share/cmake/Modules
	emake findcompiz_install
	emake install
	popd ${CMAKE_BUILD_DIR}

	insinto /etc/compizconfig
	doins "${WORKDIR}/debian/unity.ini"

	exeinto /usr/bin
	doexe "${WORKDIR}/debian/compiz-decorator"

	exeinto /usr/bin
	doexe "${FILESDIR}/update-gconf-defaults"

	insinto /usr/share/compiz
	doins -r "${FILESDIR}/gconf-defaults"

}
