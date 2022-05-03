# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="jammy"
inherit autotools ubuntu-versionator

UVER="-${PVR_MICRO}"

DESCRIPTION="Panel indicator applet"
HOMEPAGE="https://github.com/AyatanaIndicators/libayatana-indicator"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
RDEPEND="dev-libs/ayatana-ido
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
		../configure --prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--enable-debug \
		--disable-static \
		--with-gtk=2 || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
		../configure --prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--enable-debug \
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

	prune_libtool_files --modules
	# Remove dummy files as per Ubuntu, unused and file collide with dev-libs/libindicator #
	rm -fv "${ED}"/usr/$(get_libdir)/libdummy-indicator*
}
