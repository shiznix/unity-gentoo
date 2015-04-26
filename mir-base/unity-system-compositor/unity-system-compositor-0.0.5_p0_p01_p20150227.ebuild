# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="vivid"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Compositor for Mir display server that switches graphics and input between running sessions"
HOMEPAGE="https://launchpad.net/unity-system-compositor"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="dev-libs/boost:=
	dev-libs/protobuf
	media-libs/mesa[egl,gbm,gles2]
	mir-base/mir:=
	x11-base/xorg-server[mir]"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"	# This needs to be applied for the debian/ directory to be present #
}

src_install() {
	cmake-utils_src_install

	insinto /etc/lightdm/lightdm.conf.d
	doins debian/10-unity-system-compositor.conf

	exeinto /usr/bin
	doexe debian/unity-system-compositor.sleep
}
