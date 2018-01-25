# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_5,3_6} )
DISTUTILS_SINGLE_IMPL=1

URELEASE="artful"
inherit gnome2-utils distutils-r1 ubuntu-versionator

UURL="mirror://unity/pool/universe/o/${PN}"

DESCRIPTION="Simple on-screen Keyboard with macros and easy layout creation"
HOMEPAGE="https://launchpad.net/onboard"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""

# Let people emerge this by default, bug #472932
IUSE+=" +python_single_target_python3_5 python_single_target_python3_6"
RESTRICT="mirror"

RDEPEND="app-accessibility/at-spi2-core
	app-text/iso-codes
	dev-libs/glib:2
	dev-libs/libappindicator
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	gnome-base/dconf
	gnome-extra/mousetweaks
	media-libs/libcanberra
	x11-libs/cairo[svg]
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libxkbfile
	x11-libs/pango"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	distutils-r1_src_prepare

	# If a .desktop file does not have inline translations, fall back #
	#  to calling gettext #
	find ${WORKDIR} -type f -name "*.desktop*" \
		-exec sh -c 'sed -i -e "/\[Desktop Entry\]/a X-GNOME-Gettext-Domain=${PN}" "$1"' -- {} \;
}

src_install() {
	distutils-r1_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"
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
