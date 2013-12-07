# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/r/${PN}"
URELEASE="trusty"

DESCRIPTION="Ubuntu One rhythmbox plugin for the Unity desktop"
HOMEPAGE="https://launchpad.net/rhythmbox-ubuntuone"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libpeas[${PYTHON_USEDEP}]
	dev-libs/libzeitgeist
	dev-python/dirspec[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=dev-python/twisted-core-13.0.0[${PYTHON_USEDEP}]
	gnome-base/gnome-menus:3
	>=media-sound/rhythmbox-2.98[${PYTHON_USEDEP},dbus,python,zeitgeist]
	unity-base/ubuntuone-client[${PYTHON_USEDEP}]
	unity-base/unity
	$(vala_depend)"

src_install() {
	distutils-r1_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"
}
