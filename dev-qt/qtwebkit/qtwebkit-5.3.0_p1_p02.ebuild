# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit autotools eutils python-any-r1 qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/main/q/${QT5_MODULE}-opensource-src"
URELEASE="utopic"

SRC_URI="${UURL}/${QT5_MODULE}-opensource-src_${PV}+dfsg.orig.tar.xz
	${UURL}/${QT5_MODULE}-opensource-src_${PV}+dfsg-${UVER}.debian.tar.xz"

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"
#KEYWORDS="~amd64 ~x86"

# FIXME: tons of automagic deps
IUSE="libxml2 multimedia opengl qml udev webp widgets xslt"
RESTRICT="mirror"

RDEPEND="dev-db/sqlite
	dev-libs/glib:2
	dev-qt/qt3d
	>=dev-qt/qtcore-${PV}:5[debug=,icu]
	>=dev-qt/qtgui-${PV}:5[debug=,xcb]
	>=dev-qt/qtlocation-5.2.1:5[debug=]
	>=dev-qt/qtnetwork-${PV}:5[debug=]
	>=dev-qt/qtprintsupport-${PV}:5[debug=]
	>=dev-qt/qtsensors-${PV}:5[debug=]
	>=dev-qt/qtsql-${PV}:5[debug=]
	>=dev-qt/qttest-${PV}:5[debug=]
	media-libs/fontconfig
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/libpng:0=
	sys-libs/zlib
	virtual/jpeg:0
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXrender
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
export PATH="/usr/$(get_libdir)/qt5/bin:${PATH}"	# Need to see QT5's qmake

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

	# bug 458222
	sed -i -e '/SUBDIRS += examples/d' Source/QtWebKit.pro || die

	qt5-build_src_prepare
}

src_configure() {
	# Force use of gstreamer:1.0 #
	#  This ensures to workaround bad syntax in Tools/qmake/mkspecs/features/features.prf #
	#   where both versions of gstreamer can incorrectly be enabled at the same time, see error below #
	# PlatformVideoWindowQt.cpp:(.text._ZN7WebCore21FullScreenVideoWindowC2Ev+0x19): undefined reference to `vtable for WebCore::FullScreenVideoWindow' #
	qmake \
		WEBKIT_CONFIG-=use_gstreamer010 \
		WEBKIT_CONFIG+=use_gstreamer

	# Hack to fix linktime paths for geolocation (see b.g.o #451456) #
	#  NB - This is caused by library paths being present #
	#	for QMAKE_PRL_LIBS variable in /usr/lib64/libQt5*.prl files #
	echo "LIBS+=-L${S}/lib" >> Source/widgetsapi.pri
}
