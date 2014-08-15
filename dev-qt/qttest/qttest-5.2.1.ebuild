# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

QT5_MODULE="qtbase"

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE=""

RDEPEND="
	~dev-qt/qtcore-${PV}[debug=]
"
DEPEND="${RDEPEND}
	test? (
		>=dev-qt/qtgui-${PV}[debug=]
		~dev-qt/qtxml-${PV}[debug=]
	)
"

QT5_TARGET_SUBDIRS=(
	src/testlib
)
