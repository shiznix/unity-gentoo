# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

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

src_prepare() {
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
