# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit autotools base distutils-r1 gnome2-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="trusty"

DESCRIPTION="Ubuntu One client for the Unity desktop"
HOMEPAGE="https://launchpad.net/ubuntuone-client"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

DEPEND="${RDEPEND}"

# dev-libs/libubuntuone is dropped for Saucy as UbuntuOne project becomes a pure python only project (LP 1196684) #
RDEPEND="!dev-libs/libubuntuone
	dev-python/configglue[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/gnome-keyring-python
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/notify-python[${PYTHON_USEDEP}]
	>=dev-python/oauth-1.0[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.10[${PYTHON_USEDEP}]
	dev-python/pyinotify[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	>=dev-python/twisted-names-12.2.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-web-12.2.0[${PYTHON_USEDEP}]
	unity-base/ubuntu-sso-client[${PYTHON_USEDEP}]
	unity-base/ubuntuone-storage-protocol[${PYTHON_USEDEP}]
	x11-misc/lndir
	x11-misc/xdg-utils
	x11-themes/ubuntuone-client-data[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e "s:\[ -d \"\$HOME\/Ubuntu One\" \] \&\& ubuntuone-launch:\[ ! -d \"\$HOME\/Ubuntu One\" \] \&\& mkdir \"\$HOME/Ubuntu One\" \&\& ubuntuone-launch || ubuntuone-launch:" \
		-i "${S}/data/ubuntuone-launch.desktop.in" || die
}

src_install() {
	distutils-r1_src_install
	python_fix_shebang "${ED}"

	# Delete some files that are only useful on Ubuntu
	rm -rf "${ED}"etc/apport "${ED}"usr/share/apport
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
}
