# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="artful"
inherit autotools eutils ubuntu-versionator

UURL="mirror://unity/pool/main/g/${PN}"
UVER_PREFIX="+16.04.${PVR_MICRO}"

DESCRIPTION="An implementation of the GRAIL (Gesture Recognition And Instantiation Library) interface"
HOMEPAGE="https://launchpad.net/grail"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND=">=sys-devel/gcc-4.6
	sys-libs/mtdev
	unity-base/evemu
	unity-base/frame
	x11-libs/libXi
	test? ( sys-apps/xorg-gtest )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

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
