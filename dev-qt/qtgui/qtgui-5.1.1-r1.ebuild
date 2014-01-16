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
	KEYWORDS="~amd64"
fi

# TODO: directfb, linuxfb, ibus

IUSE="accessibility eglfs evdev gif gles2 +glib jpeg kms opengl +png udev +xcb"
REQUIRED_USE="
	eglfs? ( evdev gles2 )
	gles2? ( opengl )
	kms? ( gles2 )
"

RDEPEND="
	~dev-qt/qtcore-${PV}[debug=,glib=]
	media-libs/fontconfig
	media-libs/freetype:2
	sys-libs/zlib
	gif? ( media-libs/giflib )
	gles2? ( || (
		media-libs/mesa[egl,gles2]
		media-libs/mesa[egl,gles]
	) )
	glib? ( dev-libs/glib:2 )
	jpeg? ( virtual/jpeg:0 )
	kms? (
		media-libs/mesa[gbm]
		virtual/udev
		x11-libs/libdrm
	)
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng:0= )
	udev? ( virtual/udev )
	xcb? (
		>=x11-libs/libX11-1.5
		>=x11-libs/libXi-1.6
		x11-libs/libXrender
		>=x11-libs/libxcb-1.9.1[xkb]
		>=x11-libs/libxkbcommon-0.2.0
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

QT5_TARGET_SUBDIRS=(
	src/gui
	src/platformsupport
	src/plugins/imageformats
	src/plugins/platforms
)

pkg_setup() {
	QCONFIG_ADD=(
		$(use accessibility && echo accessibility-atspi-bridge)
		$(usev eglfs)
		$(usev evdev)
		fontconfig
		$(use gles2 && echo egl opengles2)
		$(usev kms)
		$(usev opengl)
		$(use udev && echo libudev)
		$(usev xcb)
	)
	QCONFIG_DEFINE=(
		$(use accessibility && echo QT_ACCESSIBILITY_ATSPI_BRIDGE || echo QT_NO_ACCESSIBILITY_ATSPI_BRIDGE)
		$(use eglfs && echo QT_EGLFS)
		$(use gles2 && echo QT_EGL)
		$(use jpeg && echo QT_IMAGEFORMAT_JPEG)
	)

	use opengl && QT5_TARGET_SUBDIRS+=(src/openglextensions)

	qt5-build_pkg_setup
}

src_prepare() {
	if has_version ">=x11-libs/libxcb-1.9.3"; then
		epatch -p1 "${FILESDIR}/xcb-193.patch"
	fi
	qt5-build_src_prepare
}

src_configure() {
	local dbus="-no-dbus"
	if use accessibility && use xcb; then
		dbus="-dbus"
	fi

	local gl="-no-egl -no-opengl"
	if use gles2; then
		gl="-egl -opengl es2"
	elif use opengl; then
		gl="-no-egl -opengl desktop"
	fi

	local myconf=(
		${dbus}
		$(qt_use eglfs)
		$(qt_use evdev)
		-fontconfig
		$(use gif || echo -no-gif)
		${gl}
		$(qt_use glib)
		$(qt_use jpeg libjpeg system)
		$(qt_use kms)
		$(qt_use png libpng system)
		$(use udev || echo -no-libudev)
		$(use xcb && echo -xcb -xrender)
	)
	qt5-build_src_configure
}
