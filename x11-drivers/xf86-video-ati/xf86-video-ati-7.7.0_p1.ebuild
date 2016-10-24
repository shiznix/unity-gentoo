# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

XORG_DRI=always
URELEASE="xenial"
inherit base linux-info xorg-2 ubuntu-versionator

MY_PV="${PV}"
MY_PN="xserver-xorg-video-ati"
UURL="mirror://unity/pool/main/x/${MY_PN}"
UVER="-${PVR_MICRO}"

DESCRIPTION="ATI video driver patched for Mir display server"
SRC_URI="${UURL}/${MY_PN}_${PV}.orig.tar.gz
	${UURL}/${MY_PN}_${PV}${UVER_PREFIX}${UVER}.diff.gz"
HOMEPAGE="http://www.x.org/wiki/ati/"

KEYWORDS="~amd64 ~x86"
IUSE="+glamor mir udev"
RESTRICT="mirror strip"

RDEPEND=">=x11-libs/libdrm-2.4.58[video_cards_radeon]
	>=x11-libs/libpciaccess-0.8.0
	glamor? ( x11-base/xorg-server[glamor] )
	udev? ( virtual/udev )"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xf86driproto
	x11-proto/xproto"

pkg_pretend() {
	if use kernel_linux ; then
		if kernel_is -ge 3 9; then
			CONFIG_CHECK="~!DRM_RADEON_UMS ~!FB_RADEON"
		else
			CONFIG_CHECK="~DRM_RADEON_KMS ~!FB_RADEON"
		fi
	fi
	check_extra_config
}

src_prepare() {
	if use mir; then
		epatch -p1 "${WORKDIR}/${MY_PN}_${MY_PV}${UVER}.diff"  # This needs to be applied for the debian/ directory to be present #
		ubuntu-versionator_src_prepare
	fi
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable glamor)
		$(use_enable udev)
	)
	xorg-2_src_configure
}
