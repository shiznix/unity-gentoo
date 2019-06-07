# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_5,3_6} )

URELEASE="eoan"
inherit autotools eutils python-r1 ubuntu-versionator

DESCRIPTION="Application dock for the MATE panel"
HOMEPAGE="https://github.com/robint99/dock-applet"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND=">=sys-devel/automake-1.15:1.15"
RDEPEND="
	dev-python/python-xlib[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pillow
	>=mate-base/mate-panel-1.17.0[introspection]
	x11-libs/libwnck:3[introspection]"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure(){
	econf --with-gtk3
}
