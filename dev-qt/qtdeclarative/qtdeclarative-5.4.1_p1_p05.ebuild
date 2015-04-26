# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="vivid"
inherit qt5-build ubuntu-versionator eutils

UURL="mirror://ubuntu/pool/main/q/${QT5_MODULE}-opensource-src"

DESCRIPTION="The QML and Quick modules for the Qt5 framework"
SRC_URI="${UURL}/${QT5_MODULE}-opensource-src_${PV}.orig.tar.xz
	${UURL}/${QT5_MODULE}-opensource-src_${PV}-${UVER}.debian.tar.xz"

KEYWORDS="~amd64 ~x86"
IUSE="gles2 localstorage +widgets +xml"

# qtgui[gles2=] is needed because of bug 504322
DEPEND="
	>=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtgui-${PV}:5[debug=,gles2=,opengl]
	>=dev-qt/qtnetwork-${PV}:5[debug=]
	>=dev-qt/qttest-${PV}:5[debug=]
	localstorage? ( >=dev-qt/qtsql-${PV}:5[debug=] )
	widgets? ( >=dev-qt/qtwidgets-${PV}:5[debug=] )
	xml? ( >=dev-qt/qtxmlpatterns-${PV}:5[debug=] )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${QT5_MODULE}-opensource-src-${PV}"
QT5_BUILD_DIR="${S}"

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done

	use localstorage || sed -i -e '/localstorage/d' \
		src/imports/imports.pro || die

	use widgets || sed -i -e 's/contains(QT_CONFIG, no-widgets)/true/' \
		src/qmltest/qmltest.pro || die

	qt_use_disable_mod widgets widgets \
		src/src.pro \
		tools/tools.pro \
		tools/qmlscene/qmlscene.pro \
		tools/qml/qml.pro

	qt_use_disable_mod xml xmlpatterns \
		src/imports/imports.pro \
		tests/auto/quick/quick.pro

	qt5-build_src_prepare
}
