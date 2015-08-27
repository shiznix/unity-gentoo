# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	#KEYWORDS="~amd64 ~x86"
:
fi

# FIXME: src/3rdparty/poly2tri doesn't respect CXX and CXXFLAGS
# TODO: plugins (qtjsondb, geoclue, gypsy), qml
IUSE=""

DEPEND="
	>=dev-qt/qt3d-5.0:5[debug=]
	>=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtdeclarative-${PV}:5[debug=]
	>=dev-qt/qtgui-${PV}:5[debug=,opengl]
	>=dev-qt/qtmultimedia-${PV}:5[debug=]
	>=dev-qt/qtnetwork-${PV}:5[debug=]
	>=dev-qt/qtsvg-${PV}:5[debug=]
	>=dev-qt/qtxmlpatterns-${PV}:5[debug=]
"
RDEPEND="${DEPEND}"
