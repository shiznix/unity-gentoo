# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_{6,7} )

inherit pax-utils python-any-r1 qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE=""

# qtcore is a build-time dep only
RDEPEND=""
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-qt/qtcore-${PV}:5[debug=]
	test? ( >=dev-qt/qtgui-${PV}:5[debug=] )
"

pkg_setup() {
	python-any-r1_pkg_setup
	qt5-build_pkg_setup
}

src_configure() {
	if host-is-pax; then
		echo "QT_CONFIG -= v8snapshot" >> "${QT5_BUILD_DIR}"/.qmake.cache
		QCONFIG_REMOVE=( v8snapshot )
	fi

	qt5-build_src_configure
}
