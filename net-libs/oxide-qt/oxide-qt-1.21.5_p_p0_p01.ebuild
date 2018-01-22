# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

# This package is currently full of fail causing qmlplugindump build failures for other packages such as x11-libs/content-hub when www-client/webbrowser-app is installed #
#	(see LP# 1332996 and LP# 1341565)
#	 <--LP# 1332996-->
#	qmlplugindump used at build time by other packages causes oxide-qt to be launched whereby it segfaults causing those builds to fail #
#	Segfault occurs because qmlplugindump selects the 'minimal' Qt platform, which doesn't implement QPlatformNativeInterface #
#		and oxide-qt depends on QPlatformNativeInterface for getting the native display handle #
#	Often with version bumps and new Chromium releases (which oxide-qt is derived), it breaks until upstream remember to fix it again #
#	 <--LP #1341565-->
#	Attempt to dump the plugin types to plugins.qmltypes and install that to avoid needless calls to qmlplugindump (in progress) #
#
# 'tcmalloc' is left disabled by default as the source considers this experimental

URELEASE="artful"
inherit check-reqs chromium-2 cmake-utils flag-o-matic gnome2-utils python-single-r1 ubuntu-versionator xdg-utils

UURL="mirror://unity/pool/universe/o/${PN}"
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
	dev-libs/libhybris
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
	dev-python/psutil
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
# Source expects build directory be located within source directory for relative paths to work correctly #
BUILD_DIR="${S}/${MY_P}_build"

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
	# Keep warnings as warnings, not failures #
	sed -e 's:fatal_linker_warnings = true:fatal_linker_warnings = false:g' \
		-e 's:treat_warnings_as_errors = true:treat_warnings_as_errors = false:g' \
			-i build/config/compiler/BUILD.gn || die

	# Remove variables not used by configure (CFLAGS, CPPFLAGS, CXXFLAGS, LDFLAGS) #
	sed -e "/}}/d" -i oxide/build/cmake/ChromiumBuildShim.cmake || die

	# Remove 'warning: "_FORTIFY_SOURCE" redefined' messages by ensuring gcc's built-in #
	#	_FORTIFY_SOURCE is undefined before the source attempts to define it #
	sed -e 's:${rebuild_string}:-U_FORTIFY_SOURCE ${rebuild_string}:g' \
		-i build/toolchain/gcc_toolchain.gni || die

	# Strip down custom cflags by default as can cause linktime failures #
	#  (see https://bugs.funtoo.org/browse/FL-3257) #
	use custom-cflags || strip-flags

	ubuntu-versionator_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=( 	-DUSE_GN=1
			-DBOOTSTRAP_GN=1
			-DCMAKE_VERBOSE_MAKEFILE=1
			-DENABLE_PROPRIETARY_CODECS=1)
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	else
		# prevent generate and dump debug symbols to save diskspace
		CMAKE_BUILD_TYPE="Release"
	fi
	use plugins && mycmakeargs+=(-DENABLE_PLUGINS=1)
	cmake-utils_src_configure
}
