# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

URELEASE="xenial"
inherit check-reqs cmake-utils python-single-r1 ubuntu-versionator

UURL="mirror://unity/pool/main/o/${PN}"
DESCRIPTION="Web browser engine library for Qt"
HOMEPAGE="https://launchpad.net/oxide"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug +plugins"
RESTRICT="mirror"

DEPEND="dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
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
	>=sys-devel/gcc-4.8
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
	ubuntu-versionator_src_prepare
	cmake-utils_src_prepare
	epatch "${FILESDIR}/${PN}-1.2.5-remove-_FORTIFY_SOURCE-warning.patch"

	# Fix sandbox violation #
	sed -e "s:\${CMAKE_INSTALL_PREFIX}:${ED}\${CMAKE_INSTALL_PREFIX}:g" \
		-i qt/CMakeLists.txt || die
}

src_configure() {
	mycmakeargs+=(-DENABLE_PROPRIETARY_CODECS=1)

	if use plugins; then
		mycmakeargs+=(-DENABLE_PLUGINS=1)
	fi

	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	else
		# prevent generate and dump debug symbols to save diskspace
		CMAKE_BUILD_TYPE="Release"
	fi

	cmake-utils_src_configure
}
