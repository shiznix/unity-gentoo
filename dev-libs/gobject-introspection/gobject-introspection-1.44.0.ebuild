# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

URELEASE="wily"
inherit eutils gnome2-utils python-single-r1 toolchain-funcs ubuntu-versionator

UVER="-1"

DESCRIPTION="Introspection infrastructure for generating gobject library bindings for various languages"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"
SRC_URI="mirror://gnome.org/pub/gnome/sources/${PN}/${PV}/${P}.tar.xz"
LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cairo doctool test"

RDEPEND=">=dev-libs/gobject-introspection-common-${PV}
	>=dev-libs/glib-2.36:2
	doctool? ( dev-python/mako )
	virtual/libffi:=
	!<dev-lang/vala-0.20.0"

# Wants real bison, not virtual/yacc
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.15
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	${PYTHON_DEPS}"
# PDEPEND to avoid circular dependencies, bug #391213
PDEPEND="cairo? ( x11-libs/cairo[glib] )"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	# To prevent crosscompiling problems, bug #414105
	CC=$(tc-getCC)

	# avoid GNU-isms
	sed -i -e 's/\(if test .* \)==/\1=/' configure || die

	if ! has_version "x11-libs/cairo[glib]"; then
		# Bug #391213: enable cairo-gobject support even if it's not installed
		# We only PDEPEND on cairo to avoid circular dependencies
		export CAIRO_LIBS="-lcairo -lcairo-gobject"
		export CAIRO_CFLAGS="-I${EPREFIX}/usr/include/cairo"
	fi
}
src_configure(){
	econf --disable-static \
		YACC=$(type -p yacc) \
		$(use_with cairo) \
		$(use_enable doctool)
}

src_install() {
	emake DESTDIR="${ED}" install
	dodoc AUTHORS CONTRIBUTORS ChangeLog NEWS README TODO

	# Prevent collision with gobject-introspection-common
	rm -v "${ED}"usr/share/aclocal/introspection.m4 \
		"${ED}"usr/share/gobject-introspection-1.0/Makefile.introspection || die
	rmdir "${ED}"usr/share/aclocal || die

	prune_libtool_files --modules
}
