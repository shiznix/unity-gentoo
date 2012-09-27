EAPI=4

inherit base gnome2 cmake-utils eutils python

UURL="http://archive.ubuntu.com/ubuntu/pool/main/c/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/-/_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Compiz Fusion OpenGL window and compositing manager patched for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}+bzr3377.orig.tar.gz
	${UURL}/${MY_P}+bzr3377-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

S="${WORKDIR}/${PN}-0.9.8.3"	# WTF?!

COMMONDEPEND="!unity-base/ccsm
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
	>=gnome-base/librsvg-2.14.0:2
	media-libs/libpng
	<=media-libs/mesa-8.0.4
	=x11-base/xorg-server-1.12.3-r9999
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
	>=x11-libs/startup-notification-0.7"

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
	epatch "${WORKDIR}/${MY_P}+bzr3377-${UVER}.diff"        # This needs to be applied for the debian/ directory to be present #
	for patch in $(cat "${S}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${S}/debian/patches/${patch}" )
	done

	# Set compiz Window Decorations to !state=maxvert so top appmenu bar behaviour functions correctly #
	PATCHES+=( "${FILESDIR}/${PN}-0.9.8_decor-setting.diff" )

	base_src_prepare

	# Fix DESTDIR #
	epatch "${FILESDIR}/${PN}-0.9.8.0_base.cmake.diff"
	einfo "Fixing DESTDIR for the following files:"
	for file in $(grep -r 'DESTINATION \$' * | grep -v DESTDIR | awk -F: '{print $1}' | uniq); do
		echo "    "${file}""
		sed -e "s:DESTINATION :DESTINATION \${COMPIZ_DESTDIR}:g" \
			-i "${file}"
	done

	# Fix installation of ccsm and compizconfig-python #
	sed -e "/message/d" \
		-i compizconfig/cmake/exec_setup_py_with_destdir.cmake || die
	sed -e "s:\${INSTALL_ROOT_ARGS}:--root=${D}:g" \
		-i compizconfig/cmake/exec_setup_py_with_destdir.cmake || die
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DCOMPIZ_BIN_PATH="/usr/bin"
		-DCOMPIZ_BUILD_WITH_RPATH=FALSE
		-DCOMPIZ_DISABLE_SCHEMAS_INSTALL=ON
		-DCOMPIZ_INSTALL_GCONF_SCHEMA_DIR="${D}etc/gconf/schemas"
		-DCOMPIZ_PACKAGING_ENABLED=ON
		-DCOMPIZ_DISABLE_PLUGIN_KDE=ON
		-DUSE_KDE4=OFF
		-DUSE_GNOME=OFF
		-DUSE_GTK=ON
		-DUSE_GSETTINGS=ON
		-DCOMPIZ_DISABLE_GS_SCHEMAS_INSTALL=OFF
		-DCOMPIZ_BUILD_TESTING=OFF
		-DCOMPIZ_DESTDIR="${D}"
		-DCOMPIZ_SYSCONFDIR="${D}etc"
		-DCMAKE_MODULE_PATH="${D}usr/share/cmake"
		-DCOMPIZ_DEFAULT_PLUGINS="ccp"
		"
	cmake-utils_src_configure
}

src_install() {
	pushd ${CMAKE_BUILD_DIR}
		emake findcompiz_install
		emake findcompizconfig_install
		emake install

		# Window manager desktop file for GNOME #
		insinto /usr/share/gnome/wm-properties/
		doins gtk/gnome/compiz.desktop

		# Keybinding files #
		insinto /usr/share/gnome-control-center/keybindings
		doins -r gtk/gnome/*.xml

	popd ${CMAKE_BUILD_DIR}

	pushd ${CMAKE_USE_DIR}

		# Docs #
		dodoc AUTHORS NEWS README
		doman debian/{ccsm,compiz,gtk-window-decorator}.1

		# X11 startup script #
		insinto /etc/X11/xinit/xinitrc.d/
		doins debian/65compiz_profile-on-session

		# Unity Compiz profile configuration file #
		insinto /etc/compizconfig
		doins debian/unity.ini

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
		insinto /usr/bin
		doins "${FILESDIR}/compiz.reset"

		# Script for migrating GConf settings to GSettings #
		insinto /usr/lib/compiz/
		doins postinst/migration-scripts/02_migrate_to_gsettings.py
		insinto /etc/xdg/autostart/
		doins "${FILESDIR}/compiz-migrate-to-dconf.desktop"

	popd ${CMAKE_USE_DIR}
}
