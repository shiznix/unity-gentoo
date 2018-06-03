# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_5,3_6} )

URELEASE="bionic"
inherit distutils-r1 ubuntu-versionator

UVER_PREFIX="+17.04.${PVR_MICRO}"

DESCRIPTION="Utility to write and run integration tests easily"
HOMEPAGE="https://launchpad.net/autopilot"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="app-i18n/ibus[introspection]
	dev-libs/glib:2
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pyjunitxml
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/PyQt4[dbus,${PYTHON_USEDEP}]
	dev-python/python-xlib
	dev-python/python-testscenarios
	dev-python/testtools[${PYTHON_USEDEP}]
	gnome-base/gconf[introspection]
	gnome-extra/zeitgeist
	unity-base/compiz
	x11-libs/gtk+:3[introspection]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
