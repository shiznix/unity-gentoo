# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/t/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Telephony service components for Ubuntu"
HOMEPAGE="https://launchpad.net/telephony-service"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="sys-auth/polkit-pkla-compat"
DEPEND="${RDEPEND}
	dev-libs/libusermetrics
	dev-qt/qtmultimedia:5
	net-libs/libphonenumber
	net-libs/telepathy-qt[qt5]
	net-misc/history-service
	unity-indicators/indicator-messages
	x11-libs/gsettings-qt
	x11-libs/libnotify"

S="${WORKDIR}"
#export PATH="/usr/$(get_libdir)/qt5/bin:${PATH}"	# Need to see QT5's qmake
export QT_SELECT=5

src_prepare() {
	ubuntu-versionator_src_prepare
	# Don't build tests as they fail to compile #
	sed -i '/add_subdirectory(tests)/d' "${S}/CMakeLists.txt" || die
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=(-DCMAKE_INSTALL_LOCALSTATEDIR=/var)
	cmake-utils_src_configure
}


src_install() {
	cmake-utils_src_install
        find "${ED}" -name "*.pkla" -exec chown root:polkitd {} \;
}
