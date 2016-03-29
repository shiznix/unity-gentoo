# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="wily"
inherit eutils qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/main/q/${QT5_MODULE}-opensource-src"
SRC_URI="${UURL}/${QT5_MODULE}-opensource-src_${PV}${UVER_PREFIX}.orig.tar.xz
	${UURL}/${QT5_MODULE}-opensource-src_${PV}${UVER_PREFIX}-${UVER}.debian.tar.gz"

DESCRIPTION="The Multimedia module for the Qt5 framework"
KEYWORDS="~amd64 ~x86"

IUSE="alsa +gstreamer openal +opengl pulseaudio qml widgets"
RESTRICT="mirror"

# "widgets? ( qtgui[opengl=] )" because of bug 518542 comment 2
RDEPEND=">=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtgui-${PV}:5
	>=dev-qt/qtnetwork-${PV}:5
	alsa? ( media-libs/alsa-lib )
	gstreamer? (
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-bad:0.10
		media-libs/gst-plugins-base:0.10
	)
	pulseaudio? ( media-sound/pulseaudio )
	qml? (
		>=dev-qt/qtdeclarative-${PV}:5
		openal? ( media-libs/openal )
	)
	widgets? (
		>=dev-qt/qtgui-${PV}:5
		>=dev-qt/qtwidgets-${PV}:5
		opengl? ( >=dev-qt/qtopengl-${PV}:5 )
	)"
DEPEND="${RDEPEND}
	x11-proto/videoproto"

S="${WORKDIR}/${QT5_MODULE}-opensource-src-${PV}"
QT5_BUILD_DIR="${S}"
QT_SELECT=5

src_prepare() {
	ubuntu-versionator_src_prepare

	qt_use_compile_test alsa
	qt_use_compile_test gstreamer
	qt_use_compile_test openal
	qt_use_compile_test pulseaudio

	qt_use_disable_mod opengl opengl \
		src/multimediawidgets/multimediawidgets.pro

	qt_use_disable_mod qml quick \
		src/src.pro

	qt_use_disable_mod widgets widgets \
		src/src.pro \
		src/gsttools/gsttools.pro \
		src/plugins/gstreamer/common.pri

	qt5-build_src_prepare
}
