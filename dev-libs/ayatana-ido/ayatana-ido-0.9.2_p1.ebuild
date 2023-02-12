# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="kinetic"
VALA_USE_DEPEND="vapigen"
inherit cmake ubuntu-versionator vala

UVER="-${PVR_MICRO}"

DESCRIPTION="Widgets and other objects used for Ayatana Indicators"
HOMEPAGE="https://github.com/AyatanaIndicators/ayatana-ido"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
RDEPEND="dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	$(vala_depend)"


src_configure() {
	mycmakeargs+=( -DVALA_COMPILER=$(type -P valac-${VALA_MIN_API_VERSION})
			-DVAPI_GEN=$(type -P vapigen-${VALA_MIN_API_VERSION})
			-DCMAKE_INSTALL_DATADIR=/usr/share )
	cmake_src_configure
}
