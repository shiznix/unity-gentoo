# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit git-r3 gnome2-utils

MY_PN="indicator-netspeed-unity"

DESCRIPTION="Network speed indicator for Unity"
HOMEPAGE="https://github.com/GGleb/indicator-netspeed-unity"
EGIT_REPO_URI="https://github.com/GGleb/${MY_PN}.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="net-analyzer/nethogs"

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
