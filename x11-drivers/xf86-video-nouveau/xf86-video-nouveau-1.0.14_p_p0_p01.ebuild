# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
XORG_DRI="always"

URELEASE="zesty"
inherit base eutils xorg-2 ubuntu-versionator

MY_PV="${PV}"
MY_PN="xserver-xorg-video-nouveau"
UURL="mirror://unity/pool/main/x/${MY_PN}"

DESCRIPTION="Accelerated Open Source driver for nVidia cards"
HOMEPAGE="http://nouveau.freedesktop.org/"
SRC_URI="${UURL}/${MY_PN}_${PV}.orig.tar.gz
	${UURL}/${MY_PN}_${PV}-${UVER}.diff.gz"

#KEYWORDS="~amd64 ~x86"
IUSE="mir"
RESTRICT="mirror strip"

RDEPEND=">=x11-libs/libdrm-2.4.60[video_cards_nouveau]
	>=x11-libs/libpciaccess-0.10"
DEPEND="${RDEPEND}"

src_prepare() {
	if use mir; then
		epatch -p1 "${WORKDIR}/${MY_PN}_${MY_PV}-${UVER}.diff"	# This needs to be applied for the debian/ to be present #
		ubuntu-versionator_src_prepare
		eautoreconf
	fi
}
