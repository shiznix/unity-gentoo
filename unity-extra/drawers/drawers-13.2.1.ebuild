# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2:2.7"
RESTRICT_PYTHON_ABIS="3.*"

inherit bzr distutils gnome2-utils python ubuntu-versionator

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
	dev-libs/libunity
	dev-python/pycairo
	dev-python/pyxdg
	gnome-extra/yelp
	unity-base/compiz
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:3[introspection]"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

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
