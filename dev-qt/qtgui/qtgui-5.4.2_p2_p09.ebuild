# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

QT5_MODULE="qtbase"

URELEASE="wily"
inherit qt5-build ubuntu-versionator eutils

UURL="mirror://unity/pool/main/q/${QT5_MODULE}-opensource-src"
UVER_PREFIX="+dfsg"

DESCRIPTION="The GUI module and platform plugins for the Qt5 toolkit"
SRC_URI="${UURL}/${QT5_MODULE}-opensource-src_${PV}${UVER_PREFIX}.orig.tar.xz
	${UURL}/${QT5_MODULE}-opensource-src_${PV}${UVER_PREFIX}-${UVER}.debian.tar.xz"
RESTRICT="mirror"
KEYWORDS="~amd64 ~x86"
# TODO: directfb, linuxfb, kms integration in eglfs

# TODO: directfb, linuxfb, offscreen
IUSE="accessibility dbus egl eglfs evdev +gif gles2 gtkstyle
	+harfbuzz ibus jpeg +png +udev +xcb"
REQUIRED_USE="|| ( eglfs xcb )
	accessibility? ( dbus xcb )
	egl? ( evdev )
	eglfs? ( egl )
	ibus? ( dbus )"

RDEPEND="dev-libs/glib:2
	~dev-qt/qtcore-${PV}
	media-libs/fontconfig
	media-libs/freetype:2
	>=sys-libs/zlib-1.2.5
	virtual/opengl
	dbus? ( ~dev-qt/qtdbus-${PV} )
	egl? ( media-libs/mesa[egl] )
	evdev? ( sys-libs/mtdev )
	gtkstyle? (
		x11-libs/gtk+:2
		x11-libs/pango
		!!x11-libs/cairo[qt4]
	)
	gles2? ( media-libs/mesa[gles2] )
	harfbuzz? ( >=media-libs/harfbuzz-0.9.32:= )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0= )
	udev? ( virtual/libudev:= )
	xcb? (
		x11-libs/libICE
		x11-libs/libSM
		>=x11-libs/libX11-1.5
		>=x11-libs/libXi-1.6
		x11-libs/libXrender
		>=x11-libs/libxcb-1.10:=[xkb]
		>=x11-libs/libxkbcommon-0.4.1[X]
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)"
DEPEND="${RDEPEND}
	evdev? ( sys-kernel/linux-headers )
	udev? ( sys-kernel/linux-headers )"
PDEPEND="
	ibus? ( app-i18n/ibus )"

S="${WORKDIR}/${QT5_MODULE}-opensource-src-${PV}"
QT5_BUILD_DIR="${S}"

QT5_TARGET_SUBDIRS=(
	src/gui
	src/openglextensions
	src/platformheaders
	src/platformsupport
	src/plugins/generic
	src/plugins/imageformats
	src/plugins/platforms
	src/plugins/platforminputcontexts
	src/plugins/platformthemes
)

QT5_GENTOO_CONFIG=(
	accessibility:accessibility-atspi-bridge
	egl
	eglfs
	evdev
	evdev:mtdev:
	:fontconfig
	:system-freetype:FREETYPE
	!:no-freetype:
	!gif:no-gif:
	gles2::OPENGL_ES
	gles2:opengles2:OPENGL_ES_2
	gtkstyle:gtkstyle:
	gtkstyle:gtk2:STYLE_GTK
	!:no-gui:
	harfbuzz:system-harfbuzz:HARFBUZZ
	!harfbuzz:no-harfbuzz:
	jpeg:system-jpeg:IMAGEFORMAT_JPEG
	!jpeg:no-jpeg:
	:opengl
	png:png:
	png:system-png:IMAGEFORMAT_PNG
	!png:no-png:
	udev:libudev:
	xcb:xcb:
	xcb:xcb-glx:
	xcb:xcb-plugin:
	xcb:xcb-render:
	xcb:xcb-sm:
	xcb:xcb-xlib:
	xcb:xinput2:
	xcb::XKB
)

src_prepare() {
	ubuntu-versionator_src_prepare

	# egl_x11 is activated when both egl and xcb are enabled
	use egl && QT5_GENTOO_CONFIG+=(xcb:egl_x11) || QT5_GENTOO_CONFIG+=(egl:egl_x11)

	# avoid automagic dep on qtdbus
	use dbus || sed -i -e 's/contains(QT_CONFIG, dbus)/false/' \
		src/platformsupport/platformsupport.pro || die

	qt_use_disable_mod ibus dbus \
		src/plugins/platforminputcontexts/platforminputcontexts.pro

	qt5-build_src_prepare
	rm -rfv include/
	./bin/syncqt.pl
}

src_configure() {
	local myconf=(
		$(usex dbus -dbus-linked '')
		$(qt_use egl)
		$(qt_use eglfs)
		$(qt_use evdev)
		$(qt_use evdev mtdev)
		-fontconfig
		-system-freetype
		$(usex gif '' -no-gif)
		$(qt_use gtkstyle)
		$(qt_use harfbuzz harfbuzz system)
		$(qt_use jpeg libjpeg system)
		-opengl $(usex gles2 es2 desktop)
		$(qt_use png libpng system)
		$(qt_use udev libudev)
		$(qt_use xcb xcb system)
		$(qt_use xcb xkbcommon system)
		$(use xcb && echo -xcb-xlib -xinput2 -xkb -xrender)
	)
	qt5-build_src_configure
}

src_install() {
	qt5-build_src_install

	if use gtkstyle; then
		local tempfile=${T}/${PN}${SLOT}.sh
		cat <<-EOF > "${tempfile}"
		export GTK2_RC_FILES=\${HOME}/.gtkrc-2.0
		EOF
		insinto /etc/profile.d
		doins "${tempfile}"
	fi
}
