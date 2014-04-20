# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils python-any-r1 qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/main/q/${QT5_MODULE}-opensource-src"
URELEASE="trusty"

SRC_URI="${UURL}/${QT5_MODULE}-opensource-src_${PV}.orig.tar.xz
	${UURL}/${QT5_MODULE}-opensource-src_${PV}-${UVER}.debian.tar.gz"

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"
KEYWORDS="~amd64 ~x86"

# TODO: qtprintsupport, qttestlib, geolocation, orientation/sensors
# FIXME: tons of automagic deps
IUSE="gstreamer libxml2 multimedia opengl qml udev webp widgets xslt"
RESTRICT="mirror"

RDEPEND="dev-db/sqlite
	>=dev-qt/qtcore-${PV}:5[debug=,icu]
	>=dev-qt/qtgui-${PV}:5[debug=,xcb]
	>=dev-qt/qtlocation-5.2.1:5[debug=]
	>=dev-qt/qtnetwork-${PV}:5[debug=]
	>=dev-qt/qtsensors-${PV}:5[debug=]
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
	)"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/ruby
	sys-devel/bison
	sys-devel/flex"

S="${WORKDIR}/${QT5_MODULE}-opensource-src-${PV}"
QT5_BUILD_DIR="${S}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-any-r1_pkg_setup
	qt5-build_pkg_setup
}

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done

	use gstreamer  || epatch "${FILESDIR}/${PN}-5.2.1-disable-gstreamer.patch"
	use libxml2    || sed -i -e '/config_libxml2: WEBKIT_CONFIG += use_libxml2/d' \
		Tools/qmake/mkspecs/features/features.prf || die
	use multimedia || sed -i -e '/WEBKIT_CONFIG += video use_qt_multimedia/d' \
		Tools/qmake/mkspecs/features/features.prf || die
	use opengl     || sed -i -e '/contains(QT_CONFIG, opengl): WEBKIT_CONFIG += use_3d_graphics/d' \
		Tools/qmake/mkspecs/features/features.prf || die
	use qml        || sed -i -e '/have?(QTQUICK): SUBDIRS += declarative/d' \
		Source/QtWebKit.pro || die
	use udev       || sed -i -e '/linux: WEBKIT_CONFIG += gamepad/d' \
		Tools/qmake/mkspecs/features/features.prf || die
	use webp       || sed -i -e '/config_libwebp: WEBKIT_CONFIG += use_webp/d' \
		Tools/qmake/mkspecs/features/features.prf || die
	use widgets    || sed -i -e '/SUBDIRS += webkitwidgets/d' \
		Source/QtWebKit.pro || die
	use xslt       || sed -i -e '/config_libxslt: WEBKIT_CONFIG += xslt/d' \
		Tools/qmake/mkspecs/features/features.prf || die

	# bug 458222
	sed -i -e '/SUBDIRS += examples/d' Source/QtWebKit.pro || die

	qt5-build_src_prepare
}

#src_configure() {
#	qt5-build_src_configure
#
#	# Hack to fix linktime paths for geolocation (see b.g.o #451456) #
#	#  NB - This is caused by library paths being present #
#	#	for QMAKE_PRL_LIBS variable in /usr/lib64/libQt5*.prl files #
#	echo "LIBS+=-L${S}/lib" >> Source/widgetsapi.pri
#}
