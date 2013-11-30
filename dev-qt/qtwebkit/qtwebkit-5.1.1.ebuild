# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit python-any-r1 qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

# TODO: qtprintsupport, qttestlib, geolocation, orientation/sensors
# FIXME: tons of automagic deps

IUSE="gstreamer libxml2 multimedia opengl qml udev webp widgets xslt"

RDEPEND="
	dev-db/sqlite
	>=dev-qt/qtcore-${PV}:5[debug=,icu]
	>=dev-qt/qtgui-${PV}:5[debug=]
	>=dev-qt/qtnetwork-${PV}:5[debug=]
	>=dev-qt/qtsql-${PV}:5[debug=]
	media-libs/fontconfig
	media-libs/libpng:0=
	sys-libs/zlib
	virtual/jpeg:0
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXrender
	gstreamer? (
		dev-libs/glib:2
		>=media-libs/gstreamer-0.10.30:0.10
		>=media-libs/gst-plugins-base-0.10.30:0.10
	)
	libxml2? ( dev-libs/libxml2 )
	multimedia? ( >=dev-qt/qtmultimedia-${PV}:5[debug=] )
	opengl? ( >=dev-qt/qtopengl-${PV}:5[debug=] )
	qml? ( >=dev-qt/qtdeclarative-${PV}:5[debug=] )
	udev? ( virtual/udev )
	webp? ( media-libs/libwebp )
	widgets? ( >=dev-qt/qtwidgets-${PV}:5[debug=] )
	xslt? (
		libxml2? ( dev-libs/libxslt )
		!libxml2? ( >=dev-qt/qtxmlpatterns-${PV}:5[debug=] )
	)
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/ruby
	sys-devel/bison
	sys-devel/flex
"

pkg_setup() {
	python-any-r1_pkg_setup
	qt5-build_pkg_setup
}

src_prepare() {
	# bug 458222
	sed -i -e '/SUBDIRS += examples/d' Source/QtWebKit.pro || die

	qt5-build_src_prepare
}
