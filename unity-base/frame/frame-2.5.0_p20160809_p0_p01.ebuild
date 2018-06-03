# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="bionic"
inherit autotools eutils ubuntu-versionator

UVER_PREFIX="daily13.06.05+16.10.${PVR_MICRO}"

DESCRIPTION="uTouch Frame Library"
HOMEPAGE="https://launchpad.net/frame"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="app-text/asciidoc
	>=sys-devel/gcc-4.6
	sys-libs/mtdev
	unity-base/evemu
	x11-base/xorg-server[dmx]
	x11-libs/libXi
	test? ( sys-apps/xorg-gtest )"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure() {
	econf --enable-static=no \
		$(use_enable test integration-tests)
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
