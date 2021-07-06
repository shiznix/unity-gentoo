# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="hirsute"
#VALA_USE_DEPEND="vapigen"
inherit autotools ubuntu-versionator vala

UVER="-${PVR_MICRO}"

DESCRIPTION="Widgets and other objects used for Ayatana Indicators"
HOMEPAGE="https://github.com/AyatanaIndicators/ayatana-ido"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
RDEPEND="dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	$(vala_depend)"

src_prepare() {
	ubuntu-versionator_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}

src_install() {
	emake DESTDIR="${ED}" install
	# Delete some files that are only useful on Ubuntu
#	rm -rf "${ED}"{etc,usr/share}/apport
}
