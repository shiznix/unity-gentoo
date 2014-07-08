# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

XORG_DRI=always
inherit base linux-info xorg-2 ubuntu-versionator

MY_PV="${PV}"
MY_PN="xserver-xorg-video-ati"
UURL="mirror://ubuntu/pool/main/x/${MY_PN}"
URELEASE="trusty-updates"

DESCRIPTION="ATI video driver"
SRC_URI="${UURL}/${MY_PN}_${PV}.orig.tar.gz
	${UURL}/${MY_PN}_${PV}-${UVER}.diff.gz"

KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 ~sparc ~x86"
IUSE="glamor mir udev"
RESTRICT="mirror strip"

RDEPEND=">=x11-libs/libdrm-2.4.46[video_cards_radeon]
	glamor? ( x11-libs/glamor )
	udev? ( virtual/udev )"
DEPEND="${RDEPEND}"

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
		epatch -p1 "${WORKDIR}/${MY_PN}_${MY_PV}-${UVER}.diff"  # This needs to be applied for the debian/ directory to be present #
		for patch in $(cat "${S}/debian/patches/series" | grep -v \# ); do
			PATCHES+=( "${S}/debian/patches/${patch}" )
		done
		base_src_prepare
	fi
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable glamor)
		$(use_enable udev)
	)
	xorg-2_src_configure
}
