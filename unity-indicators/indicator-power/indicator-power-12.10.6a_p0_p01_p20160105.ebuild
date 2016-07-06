# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="xenial"
inherit cmake-utils gnome2-utils ubuntu-versionator

UURL="mirror://unity/pool/main/i/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Indicator showing power state used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-power"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="gnome-extra/gnome-power-manager"
DEPEND="${RDEPEND}
	dev-libs/glib:2
	dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate-qt
	net-misc/url-dispatcher
	sys-power/upower
	unity-base/unity-settings-daemon"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="-j1"

src_prepare() {
	ubuntu-versionator_src_prepare
	epatch "${FILESDIR}/sandbox_violations_fix.diff"
	cmake-utils_src_prepare
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
