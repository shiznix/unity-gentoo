# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="wily"
inherit qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/main/s/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"
UVER_SUFFIX="~gcc5.1"

DESCRIPTION="Single Signon oauth2 plugin used by the Unity desktop"
HOMEPAGE="https://launchpad.net/signon-plugin-oauth2"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/qjson
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	unity-base/signon-ui"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	qt5-build_src_prepare
	sed -e "s:-Werror::g" \
		-i "common-project-config.pri" || die
}

src_install() {
	qt5-build_src_install

	# Already provided by net-libs/account-plugins with sensible settings #
	rm "${ED}etc/signon-ui/webkit-options.d/www.facebook.com.conf"
}
