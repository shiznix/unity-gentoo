# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

inherit autotools base eutils gnome2 ubuntu-versionator

URELEASE=
UVER_PREFIX="~raring1"

DESCRIPTION="The GNOME menu system patched for the Unity desktop"
HOMEPAGE="http://www.gnome.org"
SRC_URI="https://launchpad.net/~gnome3-team/+archive/gnome3/+files/${MY_P}.orig.tar.xz
	https://launchpad.net/~gnome3-team/+archive/gnome3/+files/${MY_P}-${UVER}${UVER_PREFIX}.debian.tar.gz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="3"
#KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"

IUSE="debug +introspection test"
RESTRICT="mirror"

COMMON_DEPEND=">=dev-libs/glib-2.29.15:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )"
# Older versions of slot 0 install the menu editor and the desktop directories
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-menus-3.0.1-r1:0"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-libs/gjs )"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
	eautoreconf
	gnome2_src_prepare

	# Don't show KDE standalone settings desktop files in GNOME others menu
	epatch "${FILESDIR}/${PN}-3.8.0-ignore_kde_standalone.patch"
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	# Do NOT compile with --disable-debug/--enable-debug=no
	# It disables api usage checks
	G2CONF="${G2CONF}
		$(usex debug --enable-debug=yes --enable-debug=minimum)
		$(use_enable introspection)
		--disable-static"
	gnome2_src_configure
}
