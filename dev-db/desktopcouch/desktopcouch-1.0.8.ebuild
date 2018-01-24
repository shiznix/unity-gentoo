# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 eutils multilib ubuntu-versionator

DESCRIPTION="Desktop-oriented interface to CouchDB"
HOMEPAGE="https://launchpad.net/desktopcouch"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${PN}-${PV}.tar.gz"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-python/python-distutils-extra"
RDEPEND="dev-db/couchdb
	dev-python/gnome-keyring-python[${PYTHON_USEDEP}]
	dev-python/couchdb-python[${PYTHON_USEDEP}]
	dev-python/oauth[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/twisted-core[${PYTHON_USEDEP}]
	net-dns/avahi[python]"
RESTRICT="mirror test"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	distutils-r1_src_prepare
	ubuntu-versionator_src_prepare
	python_fix_shebang .
}

src_install() {
	distutils-r1_src_install

	exeinto "/usr/$(get_libdir)/${PN}"
	doexe "bin/desktopcouch-stop"
	doexe "bin/desktopcouch-service"
	doexe "bin/desktopcouch-get-port"

	if use doc; then
		insinto "/usr/share/doc/${PF}/api"
		doins "desktopcouch/records/doc/records.txt"
		doins "desktopcouch/records/doc/field_registry.txt"
		doins "desktopcouch/contacts/schema.txt"
		doman "docs/man/desktopcouch-pair.1"
	fi
}
