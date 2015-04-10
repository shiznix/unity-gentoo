# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="utopic"
inherit base autotools eutils flag-o-matic ubuntu-versionator vala virtualx

UURL="mirror://ubuntu/pool/main/libd/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Library to pass menu structure across DBus"
HOMEPAGE="https://launchpad.net/dbusmenu"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="LGPL-3"
SLOT="0/4.0.12"	# Takes *.so version
KEYWORDS="~amd64 ~x86"
IUSE="debug gtk3 +introspection"	# We force building both GTK2, GTK3, and 'introspection', but keep these in IUSE for main portage tree ebuilds
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

RDEPEND=">=dev-libs/glib-2.35.4:2
	dev-libs/dbus-glib
	dev-libs/json-glib
	dev-libs/libxml2:2
	dev-util/gtk-doc
	sys-apps/dbus
	x11-libs/gtk+:2
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	dev-libs/gobject-introspection
	dev-util/intltool
	virtual/pkgconfig
	$(vala_depend)"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	PATCHES+=( "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff" )
	base_src_prepare

	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"

	# fix for automake-1.13
	sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' configure.ac || die

	eautoreconf
}

src_configure() {
	append-flags -Wno-error #414323
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
	../configure --enable-tests \
		--prefix=/usr \
		--enable-introspection \
		--disable-static \
		--with-gtk=2 || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
	../configure --enable-tests \
		--prefix=/usr \
		--enable-introspection \
		--disable-static \
		--with-gtk=3 || die
	popd
}

src_test() { :; } #440192

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
	# Install GTK3 support #
	pushd build-gtk3
		make -C libdbusmenu-glib DESTDIR="${D}" install || die
		make -C libdbusmenu-gtk DESTDIR="${D}" install || die
		make -C tools DESTDIR="${D}" install || die
		make -C docs/libdbusmenu-glib DESTDIR="${D}" install || die
		make -C po DESTDIR="${D}" install || die
		make -C tests DESTDIR="${D}" install || die
	popd

	# Install GTK2 support #
	pushd build-gtk2
		make -C libdbusmenu-gtk DESTDIR="${D}" install || die
		make -C docs/libdbusmenu-gtk DESTDIR="${D}" install || die
		make -C tests DESTDIR="${D}" install || die
	popd

	prune_libtool_files --modules
}
