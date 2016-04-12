# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"

URELEASE="wily"
inherit autotools base gnome2 ubuntu-versionator

UURL="mirror://unity/pool/main/g/${PN}"

DESCRIPTION="The GNOME menu system, implementing the F.D.O cross-desktop spec, patched for the Unity desktop"
HOMEPAGE="http://www.gnome.org"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="3"
KEYWORDS="~amd64 ~x86"
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

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	ubuntu-versionator_src_prepare
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
