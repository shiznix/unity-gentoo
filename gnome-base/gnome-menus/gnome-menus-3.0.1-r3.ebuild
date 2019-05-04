# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2-utils python-single-r1 ubuntu-versionator

DESCRIPTION="The GNOME menu system, implementing the F.D.O cross-desktop spec"
HOMEPAGE="http://www.gnome.org"
SRC_URI="mirror://gnome/sources/${PN}/3.0/${P}.tar.bz2"
LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

IUSE="debug python +introspection"

RDEPEND="dev-libs/glib:2
	introspection? ( dev-libs/gobject-introspection )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	dev-util/intltool
	gnome-base/gnome-common
	dev-libs/gobject-introspection-common"
# eautoreconf requires gnome-common
# The actual menus are provided by slot 3
PDEPEND="gnome-base/gnome-menus:3"

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	# Only build the library (everything else is coming from slot 3)
	epatch "${FILESDIR}/${PN}-3.0.2-library-only.patch"
	# https://bugzilla.gnome.org/show_bug.cgi?id=688972
	epatch "${FILESDIR}/${PN}-3.0.1-applications-merged.patch"
	eautoreconf
}

src_configure() {
	# Do NOT compile with --disable-debug/--enable-debug=no
	# It disables api usage checks
	use debug || \
		myconf="${myconf}--enable-debug=minimum"

	econf "${myconf}" \
		--disable-static \
		$(use_enable python) \
		$(use_enable introspection)
}

src_install() {
	emake DESTDIR="${ED}" install
	prune_libtool_files --modules
}
