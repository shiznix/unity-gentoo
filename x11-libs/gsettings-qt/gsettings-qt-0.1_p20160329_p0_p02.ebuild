# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit qmake-utils ubuntu-versionator

UURL="mirror://unity/pool/main/g/${PN}"
UVER_PREFIX="+16.04.${PVR_MICRO}"
UVER_SUFFIX="~4"

DESCRIPTION="Qml bindings for GSettings."
HOMEPAGE="https://launchpad.net/gsettings-qt"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	test? ( dev-qt/qttest:5 )"

S="${WORKDIR}"
unset QT_QPA_PLATFORMTHEME
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	ubuntu-versionator_src_prepare

	# Don't pre-strip
	echo "CONFIG+=nostrip" >> "${S}"/GSettings/gsettings-qt.pro
	echo "CONFIG+=nostrip" >> "${S}"/src/gsettings-qt.pro
	echo "CONFIG+=nostrip" >> "${S}"/tests/tests.pro

	use test || \
		sed -e 's:tests/tests.pro tests/cpptest.pro::g' \
			-i "${S}"/gsettings-qt.pro
}

src_configure() {
	eqmake5
}

src_install () {
	emake INSTALL_ROOT="${ED}" install
}
