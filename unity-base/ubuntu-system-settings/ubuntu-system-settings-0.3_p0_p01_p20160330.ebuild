# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="xenial"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/universe/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="System Settings application for Ubuntu Touch"
HOMEPAGE="https://launchpad.net/ubuntu-system-settings"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/icu:=
	dev-libs/libhybris
	dev-libs/libqtdbusmock
	dev-libs/libqtdbustest
	dev-libs/libtimezonemap
	dev-libs/trust-store
	dev-qt/qtcore:5
	net-libs/ubuntuone-credentials
	net-misc/networkmanager
	sys-apps/accountsservice
	sys-apps/click
	sys-auth/polkit
	sys-power/upower"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	# Disable apt package manager dependency #
	sed -i 's:add_subdirectory(system-update)::g' \
		-i plugins/CMakeLists.txt \
		-i tests/plugins/CMakeLists.txt
	cmake-utils_src_prepare
}
