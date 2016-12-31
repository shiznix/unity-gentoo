# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python3_4 )

URELEASE="yakkety"
inherit cmake-utils gnome2-utils python-single-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="QML plugin that exposes Scopes functionality to Unity shell"
HOMEPAGE="https://launchpad.net/unity-scopes-shell"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

DEPEND="app-misc/location-service
	dev-libs/boost:=
	dev-libs/dbus-cpp
	dev-libs/libqtdbusmock
	dev-libs/libqtdbustest
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	unity-base/ubuntu-system-settings-online-accounts
	unity-base/unity
	unity-base/unity-api
	unity-base/unity-scopes-api
	x11-libs/gsettings-qt
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

S="${WORKDIR}"
export QT_SELECT=5
unset QT_QPA_PLATFORMTHEME
gnome2_environment_reset

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"	# This needs to be applied for the debian/ directory to be present #

	use doc || \
		sed -e '/add_subdirectory(docs)/d' \
			-i CMakeLists.txt

	sed -e "s:python-py34:python-3.4:g" \
		-e "s:lib/python3/dist-packages/scope_harness:lib/${EPYTHON}/site-packages/scope_harness:g" \
			-i "src/python/scope_harness/CMakeLists.txt"

	# Gentoo's lsb-release will never match the source's expected output of a Ubuntu system #
	#	Trick src/python/scope_harness/CMakeLists.txt into using python-3.4 #
	sed -e "s:.*COMMAND lsb_release.*:set(DISTRIBUTION wily):g" \
		-i CMakeLists.txt || die

	# Don't install Ubuntu specific package 'version' info file #
	sed '/${CMAKE_CURRENT_BINARY_DIR}\/version/d' \
		-i data/CMakeLists.txt

	cmake-utils_src_prepare
}
