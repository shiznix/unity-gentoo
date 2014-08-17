# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/u/${PN}"
URELEASE="utopic"
UVER_PREFIX="+14.10.20140807"

DESCRIPTION="A daemon that offers a DBus API to perform downloads"
HOMEPAGE="https://launchpad.net/ubuntu-download-manager"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror test"

COMMON_DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qttest:5
	dev-qt/qtsystems:5
"

RDEPEND="
	>=dev-libs/boost-1.55.0
	sys-apps/dbus
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/glog
	sys-libs/libnih
"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	epatch -p1 "${FILESDIR}/fix-qml-path.patch"
	epatch -p1 "${FILESDIR}/fix-pkgconfig-install-dir.patch"

	cmake-utils_src_prepare
}
