# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

URELEASE="xenial"
inherit distutils-r1 gnome2-utils ubuntu-versionator

MY_PN="classicmenu-indicator"
UURL="mirror://ubuntu/pool/universe/c/${MY_PN}"

DESCRIPTION="Indicator to provide the main menu of Gnome2/Gnome Classic for the Unity desktop environment"
HOMEPAGE="https://launchpad.net/classicmenu-indicator"
SRC_URI="${UURL}/${MY_PN}_${PV}.orig.tar.gz
	${UURL}/${MY_PN}_${PV}-${UVER}.debian.tar.xz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="dev-libs/glib:2
	dev-libs/libappindicator
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	gnome-base/gnome-menus:0[python]
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_install() {
	distutils-r1_src_install

	insinto /etc/xdg/autostart
	doins "${WORKDIR}/debian/classicmenu-indicator.desktop"

	insinto /etc/xdg/menus/
	doins "${WORKDIR}/debian/classicmenuindicatorsystem.menu"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
