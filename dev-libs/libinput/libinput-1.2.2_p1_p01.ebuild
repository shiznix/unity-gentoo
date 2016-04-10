# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

URELEASE="xenial"
inherit autotools-multilib base eutils udev ubuntu-versionator

UURL="mirror://ubuntu/pool/main/libi/${PN}"

DESCRIPTION="Library to handle input devices in Wayland"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/libinput/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="MIT"
SLOT="0/10"
#KEYWORDS="~amd64 ~x86"
IUSE="test"
# Tests require write access to udev rules directory which is a no-no for live system.
# Other tests are just about logs, exported symbols and autotest of the test library.
RESTRICT="mirror test"

RDEPEND="dev-libs/libevdev[${MULTILIB_USEDEP}]
	sys-libs/mtdev[${MULTILIB_USEDEP}]
	virtual/libudev"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
#	test? (
#		>=dev-libs/check-0.9.10
#		dev-util/valgrind
#		sys-libs/libunwind )

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure() {
	# gui can be built but will not be installed
	# building documentation silently fails with graphviz syntax errors
	local myeconfargs=(
		econf \
			--disable-documentation \
			--disable-event-gui \
			$(use_enable test tests) \
			--with-udev-dir="$(get_udevdir)"
	)
	autotools-multilib_src_configure
}

src_compile() {
	autotools-multilib_src_compile
}

src_install() {
	autotools-multilib_src_install
	prune_libtool_files
}
