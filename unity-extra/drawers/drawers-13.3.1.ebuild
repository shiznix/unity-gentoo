# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
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
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:3[introspection]"

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
