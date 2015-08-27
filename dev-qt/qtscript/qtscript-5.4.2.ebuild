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

IUSE="scripttools"

DEPEND="
	>=dev-qt/qtcore-${PV}:5[debug=]
	scripttools? (
		>=dev-qt/qtgui-${PV}:5[debug=]
		>=dev-qt/qtwidgets-${PV}:5[debug=]
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt_use_disable_mod scripttools widgets \
		src/src.pro

	qt5-build_src_prepare
}
