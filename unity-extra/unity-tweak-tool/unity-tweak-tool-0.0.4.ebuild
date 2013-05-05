# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="3:3.2"
RESTRICT_PYTHON_ABIS="2.*"

inherit distutils gnome2-utils python ubuntu-versionator

URELEASE="raring"
UURL="mirror://ubuntu/pool/universe/u/${PN}"

DESCRIPTION="Configuration manager for the Unity desktop environment"
HOMEPAGE="https://github.com/freyja-dev/unity-tweak-tool"
SRC_URI="${UURL}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/glib:2
	dev-python/pycairo
	dev-python/pyxdg
	dev-python/pygobject:3
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext"

S="${WORKDIR}/${PN}"

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
