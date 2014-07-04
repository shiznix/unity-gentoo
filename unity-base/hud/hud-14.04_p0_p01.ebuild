# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit cmake-utils distutils-r1 flag-o-matic gnome2-utils ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/h/${PN}"
URELEASE="trusty-updates"
UVER_PREFIX="+14.04.20140604"

DESCRIPTION="Backend for the Unity HUD"
HOMEPAGE="https://launchpad.net/hud"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

RDEPEND="app-accessibility/unity-voice:=
	dev-libs/libdbusmenu:=
	unity-base/bamf:="
DEPEND="${RDEPEND}
	dev-cpp/gmock
	dev-db/sqlite:3
	dev-libs/dee[${PYTHON_USEDEP}]
	>=dev-libs/glib-2.35.4[${PYTHON_USEDEP}]
	dev-libs/libqtdbusmock
	dev-perl/XML-Parser
	gnome-base/dconf
	sys-libs/libnih[dbus]
	x11-libs/gtk+:3
	x11-libs/pango
	app-accessibility/pocketsphinx[${PYTHON_USEDEP}]
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtwidgets:5
	dev-qt/qtsql:5
	dev-qt/qttest:5
	>=x11-libs/dee-qt-3.3[qt5]
	x11-libs/gsettings-qt
	dev-libs/libdbusmenu-qt[qt5]
	$(vala_depend)
	test? ( dev-util/dbus-test-runner )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	vala_src_prepare

	# Stop cmake doing the job of distutils #
	sed -e '/add_subdirectory(hudkeywords)/d' \
		-i tools/CMakeLists.txt

	# Window-stack-bridge service must be running for hud-service to return search results #
	sed -e "/@pkglibexecdir@\/hud-service/i \
		trap 'kill $\(jobs -pr\)' SIGINT SIGTERM EXIT\n \
		@pkglibexecdir@\/window-stack-bridge &" \
			-i data/dbus-activation-hack.sh.in || die

	# disable build of tests
	sed -i '/add_subdirectory(tests)/d' "${S}/CMakeLists.txt" || die
}

src_configure() {
	local mycmakeargs="${mycmakeargs}
			$(cmake-utils_use_enable test TESTS)
			-DVALA_COMPILER=$(type -P valac-0.20)
			-DVAPI_GEN=$(type -P vapigen-0.20)
			-DCMAKE_INSTALL_DATADIR=/usr/share"
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	pushd tools/hudkeywords
		distutils-r1_src_compile
	popd
}

src_install() {
	cmake-utils_src_install
	pushd tools/hudkeywords
		distutils-r1_src_install
		python_fix_shebang "${ED}"
	popd

	# Remove upstart jobs as we use xsession based scripts in /etc/X11/xinit/xinitrc.d/ #
	# /usr/libexec/hud/hud-service is started by dbus anyway, so only needed for lack of dbus support in upstart #
	rm -rf "${ED}usr/share/upstart"
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}

