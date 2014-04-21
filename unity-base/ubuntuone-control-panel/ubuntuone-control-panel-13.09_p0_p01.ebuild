# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="saucy"

DESCRIPTION="Ubuntu One control panel for the Unity desktop"
HOMEPAGE="https://launchpad.net/ubuntuone-control-panel"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/dbus-glib
	>=dev-libs/gobject-introspection-1.36
	dev-python/configglue[${PYTHON_USEDEP}]
	dev-python/configparser[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/gnome-keyring-python
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/notify-python[${PYTHON_USEDEP}]
	dev-python/oauth[${PYTHON_USEDEP}]
	dev-python/oauthlib[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/dirspec[${PYTHON_USEDEP}]
	dev-python/lazr-restfulclient[${PYTHON_USEDEP}]
	dev-python/pyinotify[${PYTHON_USEDEP}]
	dev-python/PyQt4[${PYTHON_USEDEP},dbus]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	>=dev-python/twisted-names-12.2.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-web-12.2.0[${PYTHON_USEDEP}]
	unity-base/ubuntuone-client[${PYTHON_USEDEP}]
	x11-misc/lndir
	x11-misc/xdg-utils"
DEPEND="${RDEPEND}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	distutils-r1_src_prepare
	# Enable UbuntuOne showing up in unity-control-center #
	sed -e 's:X-GNOME-PersonalSettings:X-GNOME-PersonalSettings;X-Unity-Settings-Panel;:g' \
		-i ubuntuone-installer.desktop.in
	echo "X-Unity-Settings-Panel=ubuntuone" >> ubuntuone-installer.desktop.in
}

src_install() {
	distutils-r1_src_install
	python_fix_shebang "${ED}"

	# Delete some files that are only useful on Ubuntu
	rm -rf "${ED}"etc/apport "${ED}"usr/share/apport
}
