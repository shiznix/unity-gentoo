# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="artful"
inherit autotools gnome2-utils ubuntu-versionator

UURL="mirror://unity/pool/universe/t/${PN}"
UVER="-${PVR_MICRO}"

DESCRIPTION="A Gtk+ module and Mate/Xfce/LXDE panel applets for a global menubar"
HOMEPAGE="https://git.javispedro.com/cgit/topmenu-gtk.git/about/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}${UVER}.debian.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lxde mate xfce"
RESTRICT="mirror"

DEPEND="mate-base/mate-panel
	x11-libs/gtk+:3
	x11-libs/libwnck:1"

S="${WORKDIR}/release_${PV}"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure() {
#	# Build GTK2 support #
#	[[ -d build-gtk2 ]] || mkdir build-gtk2
#	pushd build-gtk2
#		../configure --prefix=/usr \
#			--libdir="/usr/$(get_libdir)" \
#			--disable-static \
#			--with-gtk=2 \
#			--with-wnck=wnck1 \
#			$(use_enable lxde lxpanel-plugin) \
#			$(use_enable mate mate-applet) \
#			$(use_enable xfce xfce-applet)
#	popd

	# Build GTK3 support #
#	[[ -d build-gtk3 ]] || mkdir build-gtk3
#		pushd build-gtk3
#			../configure --prefix=/usr \
#				--libdir="/usr/$(get_libdir)" \
			econf \
				--disable-static \
				--with-gtk=3 \
				--with-wnck=wnck1 \
				$(use_enable lxde lxpanel-plugin) \
				$(use_enable mate mate-applet) \
				$(use_enable xfce xfce-applet)
#		popd
}

src_install() {
	# Install GTK3 support #
#	pushd build-gtk3
		emake DESTDIR="${ED}" install
#	popd

	# Install GTK2 support #
#	pushd build-gtk2
#		emake DESTDIR="${ED}" install
#	popd

	prune_libtool_files --all
}
