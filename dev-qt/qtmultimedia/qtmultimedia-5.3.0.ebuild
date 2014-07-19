# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	#KEYWORDS="~amd64"
:
fi

# FIXME: probably lots of automagic deps
# TODO: qt-widgets can be made optional
# TODO: opengl, xv

IUSE="alsa gstreamer openal pulseaudio qml"

# Possibly related to QTBUG-39216, fixed for Qt 5.4 #
#  In the meantime will only build after old version is first unmerged #
#    Remove hard block once bumped to 5.4 #
DEPEND="!!<dev-qt/qtmultimedia-5.3:5
	>=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtgui-${PV}:5[debug=]
	>=dev-qt/qtnetwork-${PV}:5[debug=]
	>=dev-qt/qtwidgets-${PV}:5[debug=]
	alsa? ( media-libs/alsa-lib )
	gstreamer? (
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-bad:0.10
		media-libs/gst-plugins-base:0.10
	)
	openal? ( media-libs/openal )
	pulseaudio? ( media-sound/pulseaudio )
	qml? ( >=dev-qt/qtdeclarative-${PV}:5[debug=] )
"
RDEPEND="${DEPEND}"
