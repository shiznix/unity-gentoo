# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python3_4 )

URELEASE="yakkety"
inherit python-single-r1 cmake-utils gnome2-utils ubuntu-versionator

UURL="mirror://unity/pool/main/libe/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="sandbox for running Deb-packaged X11-based application under a Ubuntu \"Snappy Personal\" regime"
HOMEPAGE="https://launchpad.net/libertine"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5
	dev-util/intltool
	sys-devel/gettext"

S="${WORKDIR}"
MAKEOPTS="${MAKEOPTS} -j1"
export QT_SELECT=5
unset QT_QPA_PLATFORMTHEME

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	# Correct path to python3.pc #
	MY_EPYTHON="$(echo ${EPYTHON:0:6}-${EPYTHON:6:9})"
	sed -e "s:python3:${MY_EPYTHON}:g" \
		-i CMakeLists.txt
	cmake-utils_src_prepare
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
