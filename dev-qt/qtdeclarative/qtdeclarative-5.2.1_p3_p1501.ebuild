# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build ubuntu-versionator eutils

UURL="mirror://ubuntu/pool/main/q/${QT5_MODULE}-opensource-src"
URELEASE="trusty-updates"

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"
SRC_URI="${UURL}/${QT5_MODULE}-opensource-src_${PV}.orig.tar.xz
        ${UURL}/${QT5_MODULE}-opensource-src_${PV}-${UVER}.debian.tar.xz"

KEYWORDS="~amd64 ~x86"
IUSE="+localstorage +widgets +xml"

DEPEND="
	>=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtgui-${PV}:5[debug=,opengl]
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

	# Hack to fix include paths for Qml (see b.g.o #498894) #
	sed -e 's:core-private:core-private quick-private:' \
		-i tools/qml/qml.pro || die

	use localstorage || sed -i -e '/localstorage/d' \
		src/imports/imports.pro || die

	qt_use_disable_mod widgets widgets \
		src/imports/imports.pro \
		tools/tools.pro \
		tools/qmlscene/qmlscene.pro \
		tools/qml/qml.pro

	qt_use_disable_mod xml xmlpatterns \
		src/imports/imports.pro \
		tests/auto/quick/quick.pro

	qt5-build_src_prepare
}
