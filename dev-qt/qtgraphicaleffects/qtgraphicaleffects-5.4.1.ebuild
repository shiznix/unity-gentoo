# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build virtualx

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
:
fi

IUSE=""

RDEPEND="
	>=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtdeclarative-${PV}:5
	>=dev-qt/qtxmlpatterns-${PV}:5
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtgui-${PV}:5 )
"

src_test() {
	local VIRTUALX_COMMAND="qt5-build_src_test"
	virtualmake
}
