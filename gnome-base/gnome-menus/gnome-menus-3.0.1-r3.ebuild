# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2 python-single-r1

DESCRIPTION="The GNOME menu system, implementing the F.D.O cross-desktop spec"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug python +introspection"

RDEPEND=">=dev-libs/glib-2.18
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.40

	gnome-base/gnome-common
	dev-libs/gobject-introspection-common"
# eautoreconf requires gnome-common
# The actual menus are provided by slot 3
PDEPEND="gnome-base/gnome-menus:3"

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	# Do NOT compile with --disable-debug/--enable-debug=no
	# It disables api usage checks
	if ! use debug ; then
		G2CONF="${G2CONF} --enable-debug=minimum"
	fi

	G2CONF="${G2CONF}
		--disable-static
		$(use_enable python)
		$(use_enable introspection)"

	python-single-r1_pkg_setup
}

src_prepare() {
	# Only build the library (everything else is coming from slot 3)
	epatch "${FILESDIR}/${PN}-3.0.2-library-only.patch"
	# https://bugzilla.gnome.org/show_bug.cgi?id=688972
	epatch "${FILESDIR}/${PN}-3.0.1-applications-merged.patch"
	eautoreconf
	gnome2_src_prepare
}
