# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="Hardware sensor access library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	#KEYWORDS="~amd64 ~x86"
:
fi

IUSE="qml"

RDEPEND="
	>=dev-qt/qtcore-${PV}:5[debug=]
	qml? ( >=dev-qt/qtdeclarative-${PV}:5[debug=] )
"
DEPEND="${RDEPEND}"

src_prepare() {
	qt_use_disable_mod qml quick \
		src/src.pro

	qt5-build_src_prepare
}
