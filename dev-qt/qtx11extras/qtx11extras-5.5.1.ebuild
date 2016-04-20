# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qt5-build

DESCRIPTION="Linux/X11-specific support library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	#KEYWORDS=""
#else
	#KEYWORDS="~amd64 ~x86"
:
fi

IUSE=""

RDEPEND="
	>=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtgui-${PV}[xcb]
	~dev-qt/qtwidgets-${PV}
"
DEPEND="${RDEPEND}"
