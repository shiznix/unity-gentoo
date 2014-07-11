# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

QT5_MODULE="qttools"

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	#KEYWORDS="~amd64"
:
fi

IUSE="webkit"

DEPEND="
	>=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtgui-${PV}:5[debug=]
	>=dev-qt/qtnetwork-${PV}:5[debug=]
	>=dev-qt/qtprintsupport-${PV}:5[debug=]
	>=dev-qt/qtwidgets-${PV}:5[debug=]
	>=dev-qt/qtxml-${PV}:5[debug=]
	webkit? ( >=dev-qt/qtwebkit-5.1.1:5[debug=,widgets] )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/designer
)

src_prepare() {
	qt_use_disable_mod webkit webkitwidgets \
		src/designer/src/plugins/plugins.pro

	qt5-build_src_prepare
}
