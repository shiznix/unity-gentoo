# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

URELEASE="wily"
inherit base qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/main/q/${QT5_MODULE}-opensource-src"
UVER_PREFIX="~git20130731"

SRC_URI="${UURL}/${QT5_MODULE}-opensource-src_${PV}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${QT5_MODULE}-opensource-src_${PV}${UVER_PREFIX}-${UVER}.debian.tar.gz"

DESCRIPTION="Qt 3D QML module"
KEYWORDS="~amd64 ~x86"
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
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	qt5-build_src_prepare
	perl -w /usr/$(get_libdir)/qt5/bin/syncqt.pl -version 5.2.0
}
