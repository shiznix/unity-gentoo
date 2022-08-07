# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="jammy"
inherit cmake ubuntu-versionator

UVER="-${PVR_MICRO}"

DESCRIPTION="Panel indicator applet"
HOMEPAGE="https://github.com/AyatanaIndicators/libayatana-indicator"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
RDEPEND="dev-libs/ayatana-ido
	dev-libs/glib:2
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
