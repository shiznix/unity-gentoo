# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="hirsute"
inherit autotools ubuntu-versionator vala

UVER="-${PVR_MICRO}"

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

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	ubuntu-versionator_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
		../configure --prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--disable-static \
		--with-gtk=2 || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
		../configure --prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--disable-static \
		--with-gtk=3 || die
	popd
}

src_compile() {
	# Build GTK2 support #
	pushd build-gtk2
		emake || die
	popd

	# Build GTK3 support #
	pushd build-gtk3
		emake || die
	popd
}

src_install() {
	# Install GTK2 support #
	pushd build-gtk2
		emake DESTDIR="${D}" install || die
	popd

	# Install GTK3 support #
	pushd build-gtk3
		emake DESTDIR="${D}" install || die
	popd
}
