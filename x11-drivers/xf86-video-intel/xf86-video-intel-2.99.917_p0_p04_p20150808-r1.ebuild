# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
XORG_DRI=dri

URELEASE="wily"
inherit autotools base linux-info xorg-2 ubuntu-versionator

MY_PV="${PV}"
MY_PN="xserver-xorg-video-intel"
UURL="mirror://ubuntu/pool/main/x/${MY_PN}"
UVER_PREFIX="+git${PVR_MICRO}"

DESCRIPTION="X.Org driver for Intel cards"
SRC_URI="${UURL}/${MY_PN}_${PV}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_PN}_${PV}${UVER_PREFIX}-${UVER}.diff.gz"

KEYWORDS="~amd64 ~x86 ~amd64-fbsd -x86-fbsd"
IUSE="debug +dri3 mir +sna +udev uxa xvmc"
RESTRICT="mirror strip"

REQUIRED_USE="
	|| ( sna uxa )
"

RDEPEND="x11-libs/libXext
	x11-libs/libXfixes
	>=x11-libs/pixman-0.27.1
	>=x11-libs/libdrm-2.4.29[video_cards_intel]
	sna? (
		>=x11-base/xorg-server-1.10
	)
	udev? (
		virtual/udev
	)
	xvmc? (
		x11-libs/libXvMC
		>=x11-libs/libxcb-1.5
		x11-libs/xcb-util
	)
"
DEPEND="${RDEPEND}
	>=x11-proto/dri2proto-2.6
	x11-proto/dri3proto
	x11-proto/presentproto
	x11-proto/resourceproto"

S="${WORKDIR}/${MY_PN}-${MY_PV}${UVER_PREFIX}"

src_prepare() {
	if use mir; then
		epatch -p1 "${WORKDIR}/${MY_PN}_${MY_PV}${UVER_PREFIX}-${UVER}.diff"	# This needs to be applied for the debian/ directory to be present #
		ubuntu-versionator_src_prepare
	fi
	eautoreconf
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable debug)
		$(use_enable dri3)
		$(use_enable sna)
		$(use_enable udev)
		$(use_enable uxa)
		$(use_enable xvmc)
	)
	xorg-2_src_configure
}

pkg_postinst() {
	if linux_config_exists \
		kernel_is -lt 4 3 && ! linux_chkconfig_present DRM_I915_KMS; then
		echo
		ewarn "This driver requires KMS support in your kernel"
		ewarn "  Device Drivers --->"
		ewarn "    Graphics support --->"
		ewarn "      Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)  --->"
		ewarn "      <*>   Intel 830M, 845G, 852GM, 855GM, 865G (i915 driver)  --->"
		ewarn "	      i915 driver"
		ewarn "      [*]       Enable modesetting on intel by default"
		echo
	fi
	if use dri3; then
		elog "You have 'dri3' use enabled"
		elog "To enable DRI3 you will need to create a 'Device' section"
		elog "in /etc/X11/xorg.conf.d/*.conf file and add the line:"
		elog "  Option      \"DRI\"    \"3\""
		elog "Without this line, the driver will default to DRI2"
	fi
}
