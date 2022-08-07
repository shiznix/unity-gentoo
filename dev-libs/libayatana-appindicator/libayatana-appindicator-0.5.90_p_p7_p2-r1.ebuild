# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="jammy"
inherit cmake ubuntu-versionator vala

#UVER="-${PVR_MICRO}"

DESCRIPTION="Ayatana Application Indicators"
HOMEPAGE="https://github.com/AyatanaIndicators/libayatana-appindicator"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
RDEPEND="dev-libs/glib:2
	dev-libs/libayatana-indicator
	dev-libs/libdbusmenu[gtk,gtk3]
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	$(vala_depend)"


src_configure() {
	mycmakeargs+=( -DVALA_COMPILER=$(type -P valac-${VALA_MIN_API_VERSION})
		-DVAPI_GEN=$(type -P vapigen-${VALA_MIN_API_VERSION})
		-DENABLE_BINDINGS_MONO=OFF
		-DCMAKE_INSTALL_DATADIR=/usr/share )
	cmake_src_configure
}
