# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 gnome2-utils ubuntu-versionator

DESCRIPTION="Indicator to change user privacy settings"
HOMEPAGE="http://www.florian-diesch.de/software/indicator-privacy"
SRC_URI="http://www.florian-diesch.de/software/indicator-privacy/dist/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/libappindicator
	dev-libs/glib:2
	dev-python/pygobject:3
	dev-python/pyxdg
	gnome-extra/zeitgeist
	net-libs/ubuntu-geoip
	x11-libs/gtk+:3[introspection]"
DEPEND="${RDEPEND}"
RESTRICT="mirror"

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
