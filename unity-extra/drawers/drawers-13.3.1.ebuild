# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit bzr distutils-r1 gnome2-utils ubuntu-versionator

DESCRIPTION="Organise the Unity Launcher"
HOMEPAGE="https://code.launchpad.net/drawers"
EBZR_PROJECT="${PN}"
EBZR_BRANCH="${PV}"
EBZR_REPO_URI="lp:${PN}"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-text/yelp-tools
	dev-libs/gobject-introspection
	dev-libs/libunity[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	gnome-extra/yelp
	unity-base/compiz
	x11-apps/xprop
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:3[introspection]"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	# Fix paths #
	sed -e 's:/opt/extras.ubuntu.com/drawers/bin:/usr/bin:g' \
		-i drawers/{DrawerApp,DrawersWindow}.py \
		-i help/C/topic3.page
	sed -e 's:/opt/extras.ubuntu.com/drawers/share:/usr/share:g' \
		-i drawers/{DrawersCommon,DrawersWindow}.py
	distutils-r1_src_prepare
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
	elog "This software provided as-is as upstream has been dead for some years"
	elog "Drawers are created as *.desktop files in ~/.local/share/applications"
	elog "Currently you must logout/login of the Unity desktop before drawers appear"
	elog " (see http://askubuntu.com/questions/375975/how-to-force-unity-reload-local-share-applications)"
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
