# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

URELEASE="yakkety"
inherit gnome2-utils cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Unity 8 desktop shell"
HOMEPAGE="https://launchpad.net/unity8"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+debug test"
RESTRICT="mirror"

RDEPEND="sys-auth/polkit-pkla-compat
	unity-base/ubuntu-settings-components
	unity-base/unity-scopes-shell
	x11-libs/unity-notifications
	x11-misc/ubuntu-keyboard
	x11-themes/ubuntu-themes
	x11-libs/gtk+:3[mir]"
DEPEND="${RDEPEND}
	app-misc/pay-service
	dev-libs/glib:2
	dev-libs/libevdev
	dev-libs/libhybris
	dev-libs/libsigc++:2
	dev-libs/libunity
	dev-libs/libusermetrics
	dev-perl/JSON
	dev-python/setuptools
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5[xml]
	dev-qt/qtxmlpatterns:5
	dev-util/android-headers
	dev-util/dbus-test-runner
	dev-util/pkgconfig
	media-fonts/ubuntu-font-family
	media-libs/mesa
	media-sound/pulseaudio
	net-libs/ubuntu-download-manager
	net-misc/telephony-service
	sys-apps/upstart
	sys-libs/libnih
	unity-base/hud
	unity-base/ubuntu-system-settings
	unity-base/unity-api
	unity-indicators/indicator-network
	x11-libs/dee-qt
	x11-libs/gsettings-qt
	x11-libs/libxcb
	x11-libs/qmenumodel
	x11-libs/ubuntu-ui-toolkit"

S="${WORKDIR}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	gnome2_environment_reset
}

src_prepare() {
	ubuntu-versionator_src_prepare

	# Don't install Ubuntu specific package 'version' info file #
	sed '/${CMAKE_CURRENT_BINARY_DIR}\/version/d' \
		-i data/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	use test || mycmakeargs+=(-DNO_TESTS=ON)
	mycmakeargs+=(-DCMAKE_INSTALL_LOCALSTATEDIR=/var
			-DCMAKE_BUILD_TYPE="$(usex debug debug)")
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	exeinto /usr/bin
	doexe "${FILESDIR}/unity8_run.sh"

	insinto /usr/share/upstart/sessions
	doins data/unity8{,-dash,-filewatcher}.conf

	insinto /etc/ubuntu
	doins data/devices.conf

	find "${ED}" -name "*.pkla" -exec chown root:polkitd {} \;

	# Remove all installed language files as they can be incomplete #
	# due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"
}

pkg_postinst() {
	elog "To run Unity8, open an xterm on your desktop and run '/usr/bin/unity8_run.sh'"
	gnome2_schemas_update
	ubuntu-versionator_pkg_postinst
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postrm() {
	gnome2_schemas_update
}
