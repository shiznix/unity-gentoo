# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

QT5_MODULE="qtbase"

inherit qt5-build

DESCRIPTION="Set of UI elements for creating classic desktop-style user interfaces for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	#KEYWORDS="~amd64 ~x86"
:
fi

# keep IUSE defaults in sync with qtgui
IUSE="gles2 +opengl +png +xcb"
REQUIRED_USE="
	gles2? ( opengl )
"

DEPEND="
	~dev-qt/qtcore-${PV}[debug=]
	>=dev-qt/qtgui-${PV}[debug=,gles2=,opengl=,png=,xcb?]
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/tools/uic
	src/widgets
)

QT5_GENTOO_CONFIG=(
	!:no-widgets:
)

src_configure() {
	local gl="-no-opengl"
	if use gles2; then
		gl="-opengl es2"
	elif use opengl; then
		gl="-opengl desktop"
	fi

	local myconf=(
		# copied from qtgui
		${gl}
		$(qt_use png libpng system)
		$(qt_use xcb xcb system)
		$(qt_use xcb xkbcommon system)
		$(use xcb && echo -xcb-xlib -xinput2 -xkb -xrender)
	)
	qt5-build_src_configure
}
