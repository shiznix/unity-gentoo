# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{3_4,3_5} )
DISTUTILS_SINGLE_IMPL=1

URELEASE="zesty"
inherit distutils-r1 eutils ubuntu-versionator

UURL="mirror://unity/pool/universe/m/${PN}"

DESCRIPTION="MATE desktop tweak tool"
HOMEPAGE="https://github.com/ubuntu-mate/mate-tweak"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Let people emerge this by default, bug #472932
IUSE+=" +python_single_target_python3_4 python_single_target_python3_5"

RESTRICT="mirror"

RDEPEND="
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	gnome-base/dconf
	gnome-extra/zenity
	mate-base/mate
	mate-extra/brisk-menu
	mate-extra/mate-hud
	mate-extra/mate-indicator-applet
	mate-extra/mate-media
	unity-base/compiz
	unity-indicators/indicator-application
	unity-indicators/indicator-messages
	unity-indicators/indicator-sound
	x11-apps/mesa-progs
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/topmenu-gtk[mate]
	x11-wm/metacity
	x11-misc/compton
	x11-misc/xcompmgr
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

S="${WORKDIR}/ubuntu-mate-${PN}-47c23ea77e72"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	python_fix_shebang "${ED}"
}
