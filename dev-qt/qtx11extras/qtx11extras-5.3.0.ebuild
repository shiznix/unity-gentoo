# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	#KEYWORDS="~amd64"
:
fi

IUSE=""

RDEPEND="
	~dev-qt/qtcore-${PV}[debug=]
	>=dev-qt/qtgui-${PV}[debug=,xcb]
	~dev-qt/qtwidgets-${PV}[debug=]
"
DEPEND="${RDEPEND}"

QT5_TARGET_SUBDIRS=(
	src/x11extras
)
