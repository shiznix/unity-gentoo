# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit qt5-build ubuntu-versionator

UURL="mirror://unity/pool/main/q/${PN}-opensource-src"
UVER_PREFIX="~git20141206~44f70d99"
UVER_SUFFIX="~13"

DESCRIPTION="Qt Systems module - system info"
SRC_URI="${UURL}/${PN}-opensource-src_${PV}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${PN}-opensource-src_${PV}${UVER_PREFIX}-${UVER}${UVER_SUFFIX}.debian.tar.xz"

KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	qt5-build_src_prepare
	perl -w /usr/$(get_libdir)/qt5/bin/syncqt.pl -version 5.4.0
}
