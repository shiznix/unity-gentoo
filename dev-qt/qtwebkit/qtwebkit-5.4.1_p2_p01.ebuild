# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

URELEASE="vivid"
inherit eutils python-any-r1 qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/main/q/${QT5_MODULE}-opensource-src"
UVER_PREFIX="+dfsg"

SRC_URI="${UURL}/${QT5_MODULE}-opensource-src_${PV}${UVER_PREFIX}.orig.tar.xz
	${UURL}/${QT5_MODULE}-opensource-src_${PV}${UVER_PREFIX}-${UVER}.debian.tar.xz"

DESCRIPTION="WebKit rendering library for the Qt5 framework"
KEYWORDS="~amd64 ~x86"

# TODO: qttestlib, geolocation, orientation/sensors

IUSE="gstreamer gstreamer010 multimedia opengl printsupport qml udev webp"
REQUIRED_USE="?? ( gstreamer gstreamer010 multimedia )"
RESTRICT="mirror"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/icu:=
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-qt/qt3d
	>=dev-qt/qtcore-${PV}:5[debug=,icu]
	>=dev-qt/qtgui-${PV}:5[debug=,xcb]
	>=dev-qt/qtlocation-${PV}:5[debug=]
	>=dev-qt/qtnetwork-${PV}:5[debug=]
	>=dev-qt/qtsensors-${PV}:5[debug=]
	>=dev-qt/qtsql-${PV}:5[debug=]
	>=dev-qt/qtwidgets-${PV}:5[debug=]
	media-libs/fontconfig:1.0
	media-libs/libpng:0=
	sys-libs/zlib
	virtual/jpeg:0
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXrender
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	gstreamer010? (
		dev-libs/glib:2
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-base:0.10
	)
	multimedia? ( >=dev-qt/qtmultimedia-${PV}:5[debug=,widgets] )
	opengl? ( >=dev-qt/qtopengl-${PV}:5[debug=] )
	printsupport? ( >=dev-qt/qtprintsupport-${PV}:5[debug=] )
	qml? ( >=dev-qt/qtdeclarative-${PV}:5[debug=] )
	udev? ( virtual/udev )
	webp? ( media-libs/libwebp:0= )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/ruby
	dev-util/gperf
	sys-devel/bison
	sys-devel/flex
	virtual/rubygems"

S="${WORKDIR}/${QT5_MODULE}-opensource-src-${PV}"
QT5_BUILD_DIR="${S}"
export QT_SELECT=5

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done

	if use gstreamer010; then
		epatch "${FILESDIR}/${PN}-5.3.2-use-gstreamer010.patch"
	elif ! use gstreamer; then
		epatch "${FILESDIR}/${PN}-5.2.1-disable-gstreamer.patch"
	fi
	use multimedia   || sed -i -e '/WEBKIT_CONFIG += video use_qt_multimedia/d' \
		Tools/qmake/mkspecs/features/features.prf || die
	use opengl       || sed -i -e '/contains(QT_CONFIG, opengl): WEBKIT_CONFIG += use_3d_graphics/d' \
		Tools/qmake/mkspecs/features/features.prf || die
	use printsupport || sed -i -e '/WEBKIT_CONFIG += have_qtprintsupport/d' \
		Tools/qmake/mkspecs/features/features.prf || die
	use qml          || sed -i -e '/have?(QTQUICK): SUBDIRS += declarative/d' \
		Source/QtWebKit.pro || die
	use udev         || sed -i -e '/linux: WEBKIT_CONFIG += gamepad/d' \
		Tools/qmake/mkspecs/features/features.prf || die
	use webp         || sed -i -e '/config_libwebp: WEBKIT_CONFIG += use_webp/d' \
		Tools/qmake/mkspecs/features/features.prf || die

	# bug 458222
	sed -i -e '/SUBDIRS += examples/d' Source/QtWebKit.pro || die

	qt5-build_src_prepare
}

src_configure() {
	## This should now be taken care of by gstreamer patches above, kept for testing ##
	# Force use of gstreamer:1.0 #
	#  This ensures to workaround bad syntax in Tools/qmake/mkspecs/features/features.prf #
	#   where both versions of gstreamer can incorrectly be enabled at the same time, see error below #
	# PlatformVideoWindowQt.cpp:(.text._ZN7WebCore21FullScreenVideoWindowC2Ev+0x19): undefined reference to `vtable for WebCore::FullScreenVideoWindow' #
#	qmake \
#		WEBKIT_CONFIG-=use_gstreamer010 \
#		WEBKIT_CONFIG+=use_gstreamer
	qt5-build_src_configure

	# Hack to fix linktime paths for geolocation (see b.g.o #451456) #
	#  NB - This is caused by library paths being present #
	#	for QMAKE_PRL_LIBS variable in /usr/lib64/libQt5*.prl files #
	echo "LIBS+=-L${S}/lib" >> Source/widgetsapi.pri
}
