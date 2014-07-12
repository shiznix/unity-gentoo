# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

QT5_MODULE="qtbase"

inherit qt5-build

DESCRIPTION="The GUI module and platform plugins for the Qt5 toolkit"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	#KEYWORDS="~amd64"
:
fi

# TODO: directfb, linuxfb, offscreen

IUSE="accessibility egl eglfs evdev +gif gles2 +glib harfbuzz ibus jpeg kms +opengl +png udev +xcb"
REQUIRED_USE="
	egl? ( evdev opengl )
	eglfs? ( egl )
	gles2? ( opengl )
	kms? ( egl gles2 )
"

RDEPEND="
	~dev-qt/qtcore-${PV}[debug=,glib=]
	media-libs/fontconfig
	media-libs/freetype:2
	sys-libs/zlib
	egl? ( media-libs/mesa[egl] )
	evdev? ( sys-libs/mtdev )
	gles2? ( media-libs/mesa[gles2] )
	glib? ( dev-libs/glib:2 )
	harfbuzz? ( >=media-libs/harfbuzz-0.9.12:0= )
	ibus? ( ~dev-qt/qtdbus-${PV}[debug=] )
	jpeg? ( virtual/jpeg:0 )
	kms? (
		media-libs/mesa[gbm]
		virtual/libudev:0=
		x11-libs/libdrm
	)
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng:0= )
	udev? ( virtual/libudev:0= )
	xcb? (
		x11-libs/libICE
		x11-libs/libSM
		>=x11-libs/libX11-1.5
		>=x11-libs/libXi-1.6
		x11-libs/libXrender
		>=x11-libs/libxcb-1.10[xkb]
		>=x11-libs/libxkbcommon-0.4.1[X]
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
		accessibility? ( ~dev-qt/qtdbus-${PV}[debug=] )
	)
"
DEPEND="${RDEPEND}
	evdev? ( sys-kernel/linux-headers )
	test? ( ~dev-qt/qtnetwork-${PV}[debug=] )
"
PDEPEND="
	ibus? ( app-i18n/ibus )
"

QT5_TARGET_SUBDIRS=(
	src/gui
	src/platformsupport
	src/plugins/generic
	src/plugins/imageformats
	src/plugins/platforms
)

pkg_setup() {
	QCONFIG_ADD=(
		$(use accessibility && echo accessibility-atspi-bridge)
		$(usev egl && use xcb && echo egl_x11)
		$(usev eglfs)
		$(usev evdev && echo mtdev)
		fontconfig
		$(use gles2 && echo opengles2)
		$(use harfbuzz && echo system-harfbuzz)
		$(usev kms)
		$(usev opengl)
		$(use udev && echo libudev)
		$(usev xcb && echo xcb-plugin xcb-render xcb-sm xcb-xlib)
	)
	QCONFIG_DEFINE=(
		$(use accessibility && echo QT_ACCESSIBILITY_ATSPI_BRIDGE || echo QT_NO_ACCESSIBILITY_ATSPI_BRIDGE)
		$(use egl       || echo QT_NO_EGL QT_NO_EGL_X11)
		$(use eglfs     || echo QT_NO_EGLFS)
		$(use evdev     || echo QT_NO_EVDEV)
		$(use gles2     && echo QT_OPENGL_ES QT_OPENGL_ES_2)
		$(use jpeg      || echo QT_NO_IMAGEFORMAT_JPEG)
		$(use opengl    && echo QT_OPENGL || echo QT_NO_OPENGL)
		$(use png       || echo QT_NO_IMAGEFORMAT_PNG)
	)

	use opengl && QT5_TARGET_SUBDIRS+=(src/openglextensions)
	use ibus   && QT5_TARGET_SUBDIRS+=(src/plugins/platforminputcontexts/ibus)
	use xcb    && QT5_TARGET_SUBDIRS+=(src/plugins/platforminputcontexts/compose)

	qt5-build_pkg_setup
}

src_prepare() {
	qt5-build_src_prepare
	rm -rfv include/
	./bin/syncqt.pl
}

src_configure() {
	local dbus="-no-dbus"
	if use accessibility && use xcb || use ibus; then
		dbus="-dbus"
	fi

	local gl="-no-opengl"
	if use gles2; then
		gl="-opengl es2"
	elif use opengl; then
		gl="-opengl desktop"
	fi

	local myconf=(
		${dbus}
		$(qt_use egl)
		$(qt_use eglfs)
		$(qt_use evdev)
		$(qt_use evdev mtdev)
		-fontconfig
		-system-freetype
		$(use gif || echo -no-gif)
		${gl}
		$(qt_use glib)
		$(qt_use harfbuzz harfbuzz system)
		$(qt_use jpeg libjpeg system)
		$(qt_use kms)
		$(qt_use png libpng system)
		$(qt_use udev libudev)
		$(use xcb && echo -xcb -xcb-xlib -xinput2 -xrender -sm)
	)
	qt5-build_src_configure
}
