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
	#KEYWORDS="~amd64"
:
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}[debug=]
	>=sys-apps/dbus-1.4.20
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/dbus
	src/tools/qdbusxml2cpp
	src/tools/qdbuscpp2xml
)
QCONFIG_ADD=( dbus dbus-linked )

src_configure() {
	local myconf=(
		-dbus-linked
	)
	qt5-build_src_configure
}
