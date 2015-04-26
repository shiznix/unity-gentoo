# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

QT5_MODULE="qttools"

inherit qt5-build

DESCRIPTION="WYSIWYG tool for designing and building Qt-based GUIs"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
:
fi

IUSE="declarative webkit"

DEPEND="
	>=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtgui-${PV}:5[debug=]
	>=dev-qt/qtnetwork-${PV}:5[debug=]
	>=dev-qt/qtprintsupport-${PV}:5[debug=]
	>=dev-qt/qtwidgets-${PV}:5[debug=]
	>=dev-qt/qtxml-${PV}:5[debug=]
	declarative? ( >=dev-qt/qtdeclarative-${PV}:5[debug=,widgets] )
	webkit? ( >=dev-qt/qtwebkit-${PV}:5[debug=] )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/designer
)

src_prepare() {
	qt_use_disable_mod declarative quickwidgets \
		src/designer/src/plugins/plugins.pro

	qt_use_disable_mod webkit webkitwidgets \
		src/designer/src/plugins/plugins.pro

	qt5-build_src_prepare
}
