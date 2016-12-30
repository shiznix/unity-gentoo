# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit qmake-utils ubuntu-versionator

UURL="mirror://unity/pool/main/liba/${PN}"
UVER_PREFIX="+16.04.${PVR_MICRO}"

DESCRIPTION="QT library for Single Sign On framework for the Unity desktop"
HOMEPAGE="http://code.google.com/p/accounts-sso/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-2"
SLOT="0/1.2.0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="mirror"

DEPEND="dev-libs/libaccounts-glib:=
	dev-qt/qtcore:5
	dev-qt/qtxml:5
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest:5 )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	use doc || \
		for file in $(grep -r doc/doc.pri * | grep .pro | awk -F: '{print $1}'); do
			sed -e '/doc\/doc.pri/d' -i "${file}"
		done
	use test || \
		sed -e 's:tests::g' \
			-i accounts-qt.pro
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
}
