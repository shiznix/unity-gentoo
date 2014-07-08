# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/u/${PN}"
URELEASE="trusty"
UVER_PREFIX="+14.04.20140411"

DESCRIPTION="Compositor for Mir display server that switches graphics and input between running sessions"
HOMEPAGE="https://launchpad.net/unity-system-compositor"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

RDEPEND="dev-libs/boost:=
	mir-base/mir:=
	x11-base/xorg-server[mir]"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-libs/protobuf
	media-libs/mesa[gles2,mir]
	media-libs/mesa-mir[gles2,mir]
	mir-base/mir"

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
