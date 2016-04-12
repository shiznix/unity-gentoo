# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="xenial"
inherit qt5-build ubuntu-versionator

UURL="mirror://unity/pool/universe/q/${QT5_MODULE}-opensource-src"

SRC_URI="${UURL}/${QT5_MODULE}-opensource-src_${PV}${UVER_PREFIX}.orig.tar.xz
	${UURL}/${QT5_MODULE}-opensource-src_${PV}${UVER_PREFIX}-${UVER}.debian.tar.xz"

DESCRIPTION="Qt 3D QML module"
#KEYWORDS="~amd64 ~x86"
IUSE="gles2"
RESTRICT="mirror"

DEPEND=">=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtdeclarative-${PV}:5
	>=dev-qt/qtgui-${PV}:5[gles2=]
	>=dev-qt/qtnetwork-${PV}:5
	>=dev-qt/qtopengl-${PV}:5
	>=dev-qt/qtwidgets-${PV}:5
	>=dev-qt/qtxmlpatterns-${PV}:5"
RDEPEND="${DEPEND}"

S="${WORKDIR}"
QT5_BUILD_DIR="${S}"

src_prepare() {
	ubuntu-versionator_src_prepare
	qt5-build_src_prepare
	perl -w /usr/$(get_libdir)/qt5/bin/syncqt.pl -version 5.2.0
}
