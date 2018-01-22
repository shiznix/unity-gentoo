# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

URELEASE="artful"
inherit cmake-utils distutils-r1 flag-o-matic gnome2-utils ubuntu-versionator vala

UURL="mirror://unity/pool/universe/h/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Backend for the Unity HUD"
HOMEPAGE="https://launchpad.net/hud"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="mirror"

DEPEND="dev-cpp/gmock
	dev-db/sqlite:3
	dev-libs/dee[${PYTHON_USEDEP}]
	dev-libs/glib:2[${PYTHON_USEDEP}]
	dev-libs/libdbusmenu:=
	dev-libs/libdbusmenu-qt[qt5]
	dev-libs/libqtdbusmock
	dev-perl/XML-Parser
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtwidgets:5
	dev-qt/qtsql:5
	dev-qt/qttest:5
	gnome-base/dconf
	sys-libs/libnih[dbus]
	unity-base/bamf:=
	x11-libs/dee-qt[qt5]
	x11-libs/gsettings-qt
	x11-libs/gtk+:3
	x11-libs/pango
	$(vala_depend)
	test? ( dev-util/dbus-test-runner )"

S="${WORKDIR}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	vala_src_prepare

	# Stop cmake doing the job of distutils #
	sed -e '/add_subdirectory(hudkeywords)/d' \
		-i tools/CMakeLists.txt

	# disable build of tests
	sed -i '/add_subdirectory(tests)/d' "${S}/CMakeLists.txt" || die

	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=( -DENABLE_TESTS="$(usex test)"
			-DENABLE_DOCUMENTATION="$(usex doc)"
			-DENABLE_MEMCHECK_OPTION=ON
			-DENABLE_BAMF=ON
			-DVALA_COMPILER=$(type -P valac-${VALA_MIN_API_VERSION})
			-DVAPI_GEN=$(type -P vapigen-${VALA_MIN_API_VERSION})
			-DCMAKE_INSTALL_DATADIR=/usr/share )
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
