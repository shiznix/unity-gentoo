# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="xenial"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/main/d/${PN}"

DESCRIPTION="Dconf Qt bindings for the Unity desktop"
HOMEPAGE="https://launchpad.net/dconf-qt"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/glib:2
	dev-qt/qtcore:4
	dev-qt/qtdeclarative:4
	<gnome-base/dconf-0.26"
DEPEND="${RDEPEND}"

S="${WORKDIR}/lib${PN}-0.0.0"

src_prepare() {
	ubuntu-versionator_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=(-DCMAKE_INSTALL_PREFIX=/usr
		-DIMPORT_INSTALL_DIR=lib/qt/imports/QConf
		-DCMAKE_BUILD_TYPE=Release)
	cmake-utils_src_configure
}
