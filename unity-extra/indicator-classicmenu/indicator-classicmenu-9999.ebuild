# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2:2.7"
RESTRICT_PYTHON_ABIS="3.*"
SUPPORT_PYTHON_ABIS="1"

inherit bzr distutils gnome2-utils python ubuntu-versionator

DESCRIPTION="Indicator to provide the main menu of Gnome2/Gnome Classic for the Unity desktop environment"
HOMEPAGE="https://launchpad.net/classicmenu-indicator"
EBZR_PROJECT="classicmenu-indicator"
EBZR_BRANCH="trunk"
EBZR_REPO_URI="lp:classicmenu-indicator"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/glib:2
	dev-libs/libappindicator
	dev-python/pygobject:3
	dev-python/pygtk
	gnome-base/gnome-menus:0[python]
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext"

src_prepare() {
	export EPYTHON="$(PYTHON -2)"
	python_convert_shebangs -r 2 .
	python_src_prepare
}

#src_install() {
#	distutils_src_install
#
#	exeinto /etc/X11/xinit/xinitrc.d/
#	doexe xsession/85unsettings
#	rm -rf ${ED}etc/X11/Xsession.d/
#}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
