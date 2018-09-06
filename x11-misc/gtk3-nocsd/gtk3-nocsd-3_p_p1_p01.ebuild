# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="bionic"
inherit autotools eutils ubuntu-versionator

DESCRIPTION="Disable Gtk+ 3 client side decorations (CSD)"
HOMEPAGE="https://github.com/PCMan/gtk3-nocsd"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/gobject-introspection
	dev-libs/glib:2
	x11-libs/gtk+:3"

src_prepare() {
	# Fix libdir (prefix and LD_PRELOAD) #
	local fixlib=$(get_libdir)
	sed -i \
		-e "s:/local::" \
		-e "\:(prefix):{s:/lib:/${fixlib}:}" \
		Makefile
	sed -i \
		-e "s:\(libgtk3-nocsd.so.0\):/usr/${fixlib}/\1:" \
		"${WORKDIR}"/debian/extra/51gtk3-nocsd-detect

	# Tweak manpage #
	sed -i \
		-e "s/ IN DEBIAN//" \
		-e "s/ in Debian//" \
		-e "s:Xsession.d:xinit/xinitrc.d:" \
		-e "s:gtk3-nocsd/README.Debian:${P}/README.md.bz2:" \
		"${WORKDIR}"/debian/patches/debian-specifics-in-manpage.patch

	ubuntu-versionator_src_prepare

	default
}

src_install() {
	default

	exeinto /etc/X11/xinit/xinitrc.d
	doexe "${WORKDIR}"/debian/extra/01gtk3-nocsd
	doexe "${WORKDIR}"/debian/extra/51gtk3-nocsd-detect
	doexe "${WORKDIR}"/debian/extra/70gtk3-nocsd-propagate-LD_PRELOAD
}
