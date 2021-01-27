# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_7,3_8} )
PYTHON_REQ_USE="xml"

URELEASE="groovy"
inherit gnome.org meson python-single-r1 toolchain-funcs versionator ubuntu-versionator xdg

UVER="-1"

DESCRIPTION="Introspection system for GObject-based libraries"
HOMEPAGE="https://wiki.gnome.org/Projects/GObjectIntrospection"
SRC_URI="mirror://gnome/sources/${PN}/1.$(get_version_component_range 2)/${P}.tar.xz"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
IUSE="doctool gtk-doc test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
KEYWORDS="~amd64 ~x86"

# virtual/pkgconfig needed at runtime, bug #505408
RDEPEND="
	>=dev-libs/gobject-introspection-common-${PV}
	>=dev-libs/glib-2.$(get_version_component_range 2):2
	dev-libs/libffi:=
	doctool? (
		$(python_gen_cond_dep '
			dev-python/mako[${PYTHON_MULTI_USEDEP}]
			dev-python/markdown[${PYTHON_MULTI_USEDEP}]
		')
	)
	virtual/pkgconfig
	${PYTHON_DEPS}
"
# Wants real bison, not virtual/yacc
DEPEND="${RDEPEND}
	gtk-doc? ( >=dev-util/gtk-doc-1.19
		app-text/docbook-xml-dtd:4.3
		app-text/docbook-xml-dtd:4.5
	)
	sys-devel/bison
	sys-devel/flex
	test? ( x11-libs/cairo[glib] )
"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_feature test cairo)
		$(meson_feature doctool)
		#-Dglib_src_dir
		$(meson_use gtk-doc gtk_doc)
		#-Dcairo_libname
		-Dpython="${EPYTHON}"
		#-Dgir_dir_prefix
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"/usr/bin/
	python_optimize "${ED}"/usr/$(get_libdir)/gobject-introspection/giscanner

	# Prevent collision with gobject-introspection-common
	rm -v "${ED}"/usr/share/aclocal/introspection.m4 \
		"${ED}"/usr/share/gobject-introspection-1.0/Makefile.introspection || die
	rmdir "${ED}"/usr/share/aclocal || die
}
