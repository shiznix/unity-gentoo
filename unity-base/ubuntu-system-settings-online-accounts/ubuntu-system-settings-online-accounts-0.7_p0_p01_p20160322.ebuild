# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python3_4 )

URELEASE="xenial"
inherit python-single-r1 qt5-build ubuntu-versionator

UURL="mirror://unity/pool/universe/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Online Accounts setup for Ubuntu Touch"
HOMEPAGE="https://launchpad.net/ubuntu-system-settings-online-accounts"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	mir-base/mir
	net-libs/oxide-qt
	sys-apps/click
	unity-base/signon[qt5]
	unity-base/signon-ui
	unity-base/ubuntu-system-settings
	x11-libs/libaccounts-qt
	x11-libs/libnotify
	x11-libs/ubuntu-ui-toolkit"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="${MAKEOPTS} -j1"

QT5_BUILD_DIR="${S}"
export QT_SELECT=5

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	sed -e "s:lib/python3/dist-packages:lib/${EPYTHON}/dist-packages:g" \
		-i "tests/autopilot/autopilot.pro"
	qt5-build_src_prepare
}
