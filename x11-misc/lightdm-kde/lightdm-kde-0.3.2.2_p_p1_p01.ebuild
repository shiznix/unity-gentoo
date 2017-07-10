# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_MINIMAL="4.14"
KDE_LINGUAS="cs da de el es et fi fr ga hu it ja km lt nds nl pl pt pt_BR ro sk sv uk"

URELEASE="zesty"
inherit base kde4-base ubuntu-versionator

UURL="mirror://unity/pool/universe/l/${PN}"

DESCRIPTION="LightDM KDE greeter patched for unity desktop"
HOMEPAGE="https://launchpad.net/lightdm"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"
RESTRICT="mirror"

DEPEND="dev-qt/qtdeclarative:4
	kde-frameworks/kdelibs:4
	x11-misc/lightdm[qt4]
	x11-libs/libX11"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN/-kde}-0.3.2.1	# Incorrect versioning from upstream in tarball

src_prepare() {
	ubuntu-versionator_src_prepare
}

src_configure() {
	mycmakeargs+=(-DCMAKE_INSTALL_PREFIX=/usr)
	kde4-base_src_configure
}
