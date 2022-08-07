# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_SINGLE_IMPL=1

URELEASE="jammy"
inherit cmake distutils-r1 flag-o-matic gnome2-utils ubuntu-versionator vala

UVER_PREFIX="+17.10.${PVR_MICRO}"

DESCRIPTION="Backend for the Unity HUD"
HOMEPAGE="https://launchpad.net/hud"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="mirror"

DEPEND=">=dev-cpp/gtest-1.8.1
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libcolumbus
	dev-libs/libdbusmenu:=
	dev-libs/libdbusmenu-qt
	dev-libs/libqtdbusmock
	dev-perl/XML-Parser
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtwidgets:5
	dev-qt/qtsql:5
	dev-qt/qttest:5
	gnome-base/dconf
	unity-base/bamf:=
	x11-libs/dee-qt
	x11-libs/gsettings-qt
	x11-libs/gtk+:3
	x11-libs/pango
	$(python_gen_cond_dep '
		dev-libs/dee[${PYTHON_USEDEP}]
	')
	$(vala_depend)
	test? ( dev-util/dbus-test-runner )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
CMAKE_MAKEFILE_GENERATOR="emake"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	eapply "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"
	ubuntu-versionator_src_prepare
	vala_src_prepare

	# Fix "except ..., e: SyntaxError: invalid syntax" #
	sed -i \
		-e '/except /{s/,/ as/}' \
		tools/hudkeywords/hudkeywords/cli.py

	# Stop cmake doing the job of distutils #
	sed -e '/add_subdirectory(hudkeywords)/d' \
		-i tools/CMakeLists.txt

	# disable build of tests
	sed -i '/add_subdirectory(tests)/d' "${S}/CMakeLists.txt" || die

	cmake_src_prepare
}

src_configure() {
	# cmake.eclass >=EAPI-7 forces -DBUILD_SHARED_LIBS=ON, explicitly keep it OFF so as not to break internal linking #
	#  Build failure example:
	#   Linking CXX executable hud-service
	#   GMenuCollector.cpp:(.text+0x885): undefined reference to `qtgmenu::QtGMenuImporter::GetQMenu() const'
	mycmakeargs+=( -DBUILD_SHARED_LIBS=OFF )

	mycmakeargs+=( -DENABLE_TESTS="$(usex test)"
			-DENABLE_DOCUMENTATION="$(usex doc)"
			-DENABLE_BAMF=ON
			-DVALA_COMPILER=$(type -P valac-${VALA_MIN_API_VERSION})
			-DVAPI_GEN=$(type -P vapigen-${VALA_MIN_API_VERSION})
			-DCMAKE_INSTALL_DATADIR=/usr/share )
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	pushd tools/hudkeywords
		distutils-r1_src_compile
	popd
}

src_install() {
	cmake_src_install
	pushd tools/hudkeywords
		distutils-r1_src_install
		python_fix_shebang "${ED}"
		python_optimize
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
