# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )
DISTUTILS_SINGLE_IMPL=1

URELEASE="wily"
inherit gnome2-utils distutils-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/o/${PN}"

DESCRIPTION="Simple on-screen Keyboard with macros and easy layout creation"
HOMEPAGE="https://launchpad.net/onboard"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""

# Let people emerge this by default, bug #472932
IUSE+=" python_single_target_python3_3 +python_single_target_python3_4"

RESTRICT="mirror"

RDEPEND="app-accessibility/at-spi2-core
	app-text/iso-codes
	dev-libs/glib:2
	dev-libs/libappindicator
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
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
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	distutils-r1_src_prepare
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
