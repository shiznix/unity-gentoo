# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/a/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.04.03"

DESCRIPTION="Export GTK menus over DBus"
HOMEPAGE="https://launchpad.net/appmenu-gtk"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=[gtk]"
DEPEND="${RDEPEND}
	unity-indicators/indicator-appmenu
	x11-libs/gtk+:2
	<x11-libs/gtk+-3.8.0"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eautoreconf
}

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
	../configure --prefix=/usr \
		--sysconfdir=/etc \
		--disable-static \
		--with-gtk2 || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
	../configure --prefix=/usr \
		--sysconfdir=/etc \
		--disable-static || die
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

	exeinto /etc/X11/xinit/xinitrc.d
	doexe "${D}etc/X11/Xsession.d/80appmenu"
	doexe "${D}etc/X11/Xsession.d/80appmenu-gtk3"

	rm -rvf "${D}etc/X11/Xsession.d"
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
}
