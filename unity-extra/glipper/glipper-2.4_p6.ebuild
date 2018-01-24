# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

URELEASE="artful"
inherit distutils-r1 gnome2-utils ubuntu-versionator

UURL="mirror://unity/pool/universe/g/${PN}"
UVER="-${PVR_MICRO}"

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
	dev-libs/libappindicator[${PYTHON_USEDEP}]
	dev-python/gconf-python[${PYTHON_USEDEP}]
	dev-python/pycrypto
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/python-prctl[${PYTHON_USEDEP}]
	dev-python/pyxdg"
DEPEND="${RDEPEND}
	>=dev-python/python-distutils-extra-2.37"

src_install() {
	sed -e "s:DATA_DIR = \"\":DATA_DIR = \"/usr/share\":g" \
		-i glipper/defs.py
	distutils-r1_src_install

	dodir /etc
	mv -vf "${ED}"/usr/share/gconf "${ED}"/etc

	prune_libtool_files --modules
}

pkg_preinst() {
	gnome2_gconf_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_gconf_install
	gnome2_icon_cache_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
}
