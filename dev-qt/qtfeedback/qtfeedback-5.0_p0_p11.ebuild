# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="wily"
inherit base qt5-build ubuntu-versionator virtualx

UURL="mirror://ubuntu/pool/main/q/${PN}-opensource-src"
UVER_PREFIX="~git20130529"

DESCRIPTION="Qt Feedback module"
SRC_URI="${UURL}/${PN}-opensource-src_${PV}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${PN}-opensource-src_${PV}${UVER_PREFIX}-${UVER}.debian.tar.gz"

#KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND=">=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtdeclarative-${PV}:5[debug=]
	>=dev-qt/qtmultimedia-${PV}:5[debug=]
	>=dev-qt/qtxmlpatterns-${PV}:5[debug=]
	test? ( >=dev-qt/qtgui-${PV}:5[debug=] )"

S="${WORKDIR}"

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	qt5-build_src_prepare
	perl -w /usr/$(get_libdir)/qt5/bin/syncqt.pl -version 5.0.0
}

src_test() {
	local VIRTUALX_COMMAND="qt5-build_src_test"
	virtualmake
}
