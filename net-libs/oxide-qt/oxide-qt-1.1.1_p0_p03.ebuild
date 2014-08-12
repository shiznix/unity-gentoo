# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit base cmake-utils python-single-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/o/${PN}"
URELEASE="utopic"

DESCRIPTION="Web browser engine library for Qt"
HOMEPAGE="https://launchpad.net/oxide"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtlocation:5
	dev-qt/qtnetwork:5
	dev-qt/qttest:5
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

export PATH="/usr/$(get_libdir)/qt5/bin:${PATH}"	# Need to see QT5's qmake

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
	if [[ $(gcc-major-version) -lt 4 ]] || \
		( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 8 ]] ); then
			die "${P} requires an active >=gcc-4.8, please consult the output of 'gcc-config -l'"
        fi
}

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
}

src_configure() {
	local mycmakeargs="${mycmakeargs}
		-DENABLE_PROPRIETARY_CODECS=1"
	cmake-utils_src_configure
}
