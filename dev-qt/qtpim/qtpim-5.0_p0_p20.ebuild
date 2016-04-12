# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="xenial"
inherit qt5-build ubuntu-versionator

UURL="mirror://unity/pool/main/q/${PN}-opensource-src"
UVER_PREFIX="~git20140515~29475884"

DESCRIPTION="Qt PIM module, Organizer library"
SRC_URI="${UURL}/${PN}-opensource-src_${PV}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${PN}-opensource-src_${PV}${UVER_PREFIX}-${UVER}.debian.tar.xz"

#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtdeclarative-${PV}:5
	>=dev-qt/qtxmlpatterns-${PV}:5"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	qt5-build_src_prepare
	perl -w /usr/$(get_libdir)/qt5/bin/syncqt.pl -version 5.0.0
}
