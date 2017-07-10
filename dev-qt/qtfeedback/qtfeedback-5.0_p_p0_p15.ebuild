# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit qt5-build ubuntu-versionator virtualx

UURL="mirror://unity/pool/main/q/${PN}-opensource-src"
UVER_PREFIX="~git20130529"
UVER_SUFFIX="~1"

DESCRIPTION="Qt Feedback module"
SRC_URI="${UURL}/${PN}-opensource-src_${PV}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${PN}-opensource-src_${PV}${UVER_PREFIX}-${UVER}${UVER_SUFFIX}.debian.tar.xz"

KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND=">=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtdeclarative-${PV}:5
	>=dev-qt/qtmultimedia-${PV}:5
	>=dev-qt/qtxmlpatterns-${PV}:5
	test? ( >=dev-qt/qtgui-${PV}:5 )"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	qt5-build_src_prepare
	perl -w /usr/$(get_libdir)/qt5/bin/syncqt.pl -version 5.0.0
}

src_test() {
	local VIRTUALX_COMMAND="qt5-build_src_test"
	virtualmake
}
