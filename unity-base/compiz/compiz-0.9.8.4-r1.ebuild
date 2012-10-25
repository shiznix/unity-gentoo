EAPI=4

inherit base gnome2 cmake-utils eutils python

UURL="http://archive.ubuntu.com/ubuntu/pool/main/c/${PN}"
UVER="0ubuntu2"
URELEASE="quantal"
MY_P="${P/-/_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Compiz Fusion OpenGL window and compositing manager patched for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="kde"

COMMONDEPEND="kde? ( <=kde-base/kwin-4.8.5 )
	!unity-base/ccsm
	!unity-base/compizconfig-python
	!unity-base/compizconfig-backend-gconf
	!x11-wm/compiz
	!x11-libs/compiz-bcop
	!x11-libs/libcompizconfig
	!x11-plugins/compiz-plugins-main
	>=dev-libs/boost-1.34.0
	dev-libs/glib:2
	dev-cpp/glibmm
	dev-libs/libxml2
	dev-libs/libxslt
	dev-python/pyrex
	gnome-base/gconf
	>=gnome-base/gsettings-desktop-schemas-99.3.4.1
	>=gnome-base/librsvg-2.14.0:2
	media-libs/libpng
	<=media-libs/mesa-8.0.4
	=x11-base/xorg-server-1.13.0-r9999[dmx]
	>=x11-libs/cairo-1.0
	>=x11-libs/gtk+-99.3.4.2
	x11-libs/libnotify
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
	>=x11-libs/startup-notification-0.7
	>=x11-wm/metacity-99.2.34.1"

DEPEND="${COMMONDEPEND}
	dev-util/pkgconfig
	x11-proto/damageproto
	x11-proto/xineramaproto"

RDEPEND="${COMMONDEPEND}
	x11-apps/mesa-progs
	x11-apps/xvinfo"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	# Apply Ubuntu patchset #
	epatch "${WORKDIR}/${MY_P}-${UVER}.diff"        # This needs to be applied for the debian/ directory to be present #
	for patch in $(cat "${S}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${S}/debian/patches/${patch}" )
	done

	# Set compiz Window Decorations to !state=maxvert so top appmenu bar behaviour functions correctly #
	PATCHES+=( "${FILESDIR}/${PN}-0.9.8_decor-setting.diff" )

	base_src_prepare

	# Set DESKTOP_SESSION so correct profile and it's plugins get loaded at Xsession start #
	sed -e 's:xubuntu:xunity:g' \
		-i debian/65compiz_profile-on-session || die
}

src_configure() {
        use kde && \
                mycmakeargs="${mycmakeargs} -DUSE_KDE4=ON" || \
                mycmakeargs="${mycmakeargs} -DUSE_KDE4=OFF"

	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DCOMPIZ_INSTALL_GCONF_SCHEMA_DIR="/etc/gconf/schemas"
		-DCOMPIZ_BUILD_WITH_RPATH=FALSE
		-DCOMPIZ_PACKAGING_ENABLED=TRUE
		-DUSE_GCONF=OFF
		-DUSE_GSETTINGS=ON
		-DCOMPIZ_DISABLE_GS_SCHEMAS_INSTALL=OFF
		-DCOMPIZ_BUILD_TESTING=OFF
		-DCOMPIZ_DEFAULT_PLUGINS="ccp"
		"
	cmake-utils_src_configure
}

src_compile() {
	# Disable unitymtgrabhandles plugin #
	sed -e "s:unitymtgrabhandles;::g" \
		-i "${CMAKE_USE_DIR}/debian/unity.ini"
	sed -e "s:unitymtgrabhandles,::g" \
		-i "${CMAKE_USE_DIR}/debian/compiz-gnome.gconf-defaults"
	sed -e "s:'unitymtgrabhandles',::g" \
		-i "${CMAKE_USE_DIR}/debian/compiz-gnome.gsettings-override"
}

src_install() {
	pushd ${CMAKE_BUILD_DIR}
		addpredict /root/.gconf/
		GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL=1 emake DESTDIR="${D}" install

		# Window manager desktop file for GNOME #
		insinto /usr/share/gnome/wm-properties/
		doins gtk/gnome/compiz.desktop

		# Keybinding files #
		insinto /usr/share/gnome-control-center/keybindings
		doins gtk/gnome/*.xml
	popd ${CMAKE_BUILD_DIR}

	pushd ${CMAKE_USE_DIR}
		CMAKE_DIR=$(cmake --system-information | grep '^CMAKE_ROOT' | awk -F\" '{print $2}')
		insinto "${CMAKE_DIR}/Modules/"
		doins cmake/FindCompiz.cmake
		doins compizconfig/libcompizconfig/cmake/FindCompizConfig.cmake

		# Docs #
		dodoc AUTHORS NEWS README
		doman debian/{ccsm,compiz,gtk-window-decorator}.1

		# X11 startup script #
		exeinto /etc/X11/xinit/xinitrc.d/
		doexe debian/65compiz_profile-on-session

		# Unity Compiz profile configuration file #
		insinto /etc/compizconfig
		doins debian/unity.ini
		doins debian/config

		# Compiz profile upgrade helper files for ensuring smooth upgrades from older configuration files #
		insinto /etc/compizconfig/upgrades/
		doins debian/profile_upgrades/*.upgrade
		insinto /usr/lib/compiz/migration/
		doins postinst/convert-files/*.convert

		# Default GConf settings #
		insinto /usr/share/gconf/defaults
		newins debian/compiz-gnome.gconf-defaults 10_compiz-gnome

		# Default GSettings settings #
		insinto /usr/share/glib-2.0/schemas
		newins debian/compiz-gnome.gsettings-override 10_compiz-ubuntu.gschema.override

		# Script for resetting all of Compiz's settings #
		exeinto /usr/bin
		doexe "${FILESDIR}/compiz.reset"

		# Script for migrating GConf settings to GSettings #
		insinto /usr/lib/compiz/
		doins postinst/migration-scripts/02_migrate_to_gsettings.py
		insinto /etc/xdg/autostart/
		doins "${FILESDIR}/compiz-migrate-to-dconf.desktop"
	popd ${CMAKE_USE_DIR}

	# Setup gconf defaults #
	dodir /etc/gconf/2
	if [ -z "`grep gconf.xml.unity /etc/gconf/2/local-defaults.path 2> /dev/null`" ]; then
		echo "/etc/gconf/gconf.xml.unity" >> ${D}etc/gconf/2/local-defaults.path
	fi
	dodir /etc/gconf/gconf.xml.unity 2> /dev/null
	/usr/bin/update-gconf-defaults \
		--source="${D}usr/share/gconf/defaults" \
			--destination="${D}etc/gconf/gconf.xml.unity" || die
	gnome2_gconf_install
}
