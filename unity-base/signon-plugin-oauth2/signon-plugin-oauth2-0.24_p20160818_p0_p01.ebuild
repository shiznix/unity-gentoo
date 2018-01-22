# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="artful"
inherit qmake-utils ubuntu-versionator

UURL="mirror://unity/pool/universe/s/${PN}"
UVER_PREFIX="+16.10.${PVR_MICRO}"

DESCRIPTION="Single Signon oauth2 plugin used by the Unity desktop"
HOMEPAGE="https://launchpad.net/signon-plugin-oauth2"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="example test"
RESTRICT="mirror"

DEPEND="dev-libs/qjson
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	unity-base/signon-ui
	test? ( dev-qt/qttest:5 )"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	sed -e "s:-Werror::g" \
		-i "common-project-config.pri" || die
	use example || \
		sed -e "s:tests example:tests:g" \
			-i signon-oauth2.pro || die
	use test || \
		sed -e "s:src tests:src:g" \
			-i signon-oauth2.pro || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${ED}" install

	# Already provided by net-libs/account-plugins with sensible settings #
	use example && \
		rm "${ED}etc/signon-ui/webkit-options.d/www.facebook.com.conf"
}
