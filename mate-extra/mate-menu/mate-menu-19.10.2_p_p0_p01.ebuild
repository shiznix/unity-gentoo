# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_5,3_6} )
DISTUTILS_SINGLE_IMPL=1

URELEASE="eoan"
inherit distutils-r1 eutils gnome2-utils ubuntu-versionator

DESCRIPTION="Advanced MATE menu"
HOMEPAGE="https://github.com/ubuntu-mate/mate-menu/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"

# Let people emerge this by default, bug #472932
IUSE+=" python_single_target_python3_5 +python_single_target_python3_6"
RESTRICT="mirror"

RDEPEND="dev-libs/glib:2
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	dev-python/python-xlib[${PYTHON_USEDEP}]
	mate-base/mate-desktop[introspection]
	mate-base/mate-panel[introspection]
	x11-libs/gtk+:3[introspection]
	x11-misc/xdg-utils
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	distutils-r1_src_prepare

	# Install Xsession file into correct Gentoo path #
	sed -e 's:/etc/X11/Xsession.d:/etc/X11/xinit/xinitrc.d:g' \
		-i setup.py
}

src_install() {
	distutils-r1_src_install
	python_fix_shebang "${ED}"
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
}
