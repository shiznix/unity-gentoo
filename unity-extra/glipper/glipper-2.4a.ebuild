# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
GNOME2_LA_PUNT="yes"

PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils gnome2-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/g/${PN}"
UVER="4"
URELEASE="trusty"

DESCRIPTION="A PyGTK+ based advanced clipboard manager"
HOMEPAGE="http://launchpad.net/glipper"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="!x11-misc/glipper
	dev-libs/keybinder:0[python]
	dev-libs/libappindicator
	dev-python/gconf-python
	dev-python/pycrypto
	dev-python/pygtk:2
	dev-python/python-prctl
	dev-python/pyxdg"
DEPEND="${RDEPEND}
	>=dev-python/python-distutils-extra-2.37"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python_pkg_setup
}

src_install() {
	sed -e "s:DATA_DIR = \"\":DATA_DIR = \"/usr/share\":g" \
		-i glipper/defs.py
	distutils_src_install

	dodir /etc
	mv -vf "${ED}"/usr/share/gconf "${ED}"/etc
}

pkg_preinst() {
	gnome2_gconf_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	distutils_pkg_postinst
	gnome2_gconf_install
	gnome2_icon_cache_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	distutils_pkg_postrm
	gnome2_icon_cache_update
}
