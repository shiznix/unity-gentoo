# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

# This package is currently full of fail causing qmlplugindump build failures for other packages such as x11-libs/content-hub when www-client/webbrowser-app is installed #
#	(see LP# 1332996 and LP# 1341565)
#	 <--LP#1332996-->
#	qmlplugindump used at build time by other packages causes oxide-qt to be launched whereby it segfaults causing those builds to fail #
#	Segfault occurs because qmlplugindump selects the 'minimal' Qt platform, which doesn't implement QPlatformNativeInterface #
#		and oxide-qt depends on QPlatformNativeInterface for getting the native display handle #
#	Often with version bumps and new Chromium releases (which oxide-qt is derived), it breaks until upstream remember to fix it again #
#	 <--LP #1341565-->
#	Attempt to dump the plugin types to plugins.qmltypes and install that to avoid needless calls to qmlplugindump (in progress) #
URELEASE="xenial-security"
inherit check-reqs cmake-utils flag-o-matic python-single-r1 ubuntu-versionator

UURL="mirror://unity/pool/main/o/${PN}"
DESCRIPTION="Web browser engine library for Qt"
HOMEPAGE="https://launchpad.net/oxide"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="custom-cflags debug +plugins"
RESTRICT="mirror"

DEPEND="dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-qt/qtcore:5=
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtfeedback:5
	dev-qt/qtpositioning:5
	dev-qt/qtnetwork:5
	dev-qt/qtpositioning:5
	dev-qt/qttest:5
	dev-util/ninja
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	sys-apps/dbus
	sys-libs/libcap
	virtual/libudev
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/pango"

export QT_SELECT=5

pkg_pretend() {
	if use debug; then
		CHECKREQS_DISK_BUILD="17.5G"
	else
		CHECKREQS_DISK_BUILD="3G"
	fi
	check-reqs_pkg_setup
}

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	PATCHES+=( "${FILESDIR}/${PN}-1.16.5-remove-_FORTIFY_SOURCE-warning.patch" )
	ubuntu-versionator_src_prepare

	# Strip down custom cflags by defult as can cause linktime failures #
	#  (see https://bugs.funtoo.org/browse/FL-3257) #
	use custom-cflags || strip-flags

	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=(-DENABLE_PROPRIETARY_CODECS=1)
	use plugins && mycmakeargs+=(-DENABLE_PLUGINS=1)
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	else
		# prevent generate and dump debug symbols to save diskspace
		CMAKE_BUILD_TYPE="Release"
	fi
	cmake-utils_src_configure
}
