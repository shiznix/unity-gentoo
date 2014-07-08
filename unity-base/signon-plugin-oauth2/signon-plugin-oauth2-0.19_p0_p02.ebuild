# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit base qt4-r2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/s/${PN}"
URELEASE="trusty"
UVER_PREFIX="+14.04.20140305"

DESCRIPTION="Single Signon oauth2 plugin used by the Unity desktop"
HOMEPAGE="https://launchpad.net/signon-plugin-oauth2"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/qjson
	dev-qt/qtcore:4
	unity-base/signon-ui"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	# Ubuntu patchset #
#	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
#		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
#	done
	base_src_prepare

	sed -e "s:-Werror::g" \
		-i "common-project-config.pri" || die
}

src_install() {
	qt4-r2_src_install

	# Already provided by net-libs/account-plugins with sensible settings #
	rm "${ED}etc/signon-ui/webkit-options.d/www.facebook.com.conf"
}
