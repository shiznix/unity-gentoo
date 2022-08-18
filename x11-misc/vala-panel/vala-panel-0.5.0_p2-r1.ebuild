# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="jammy"
inherit eutils gnome2-utils meson ubuntu-versionator vala

UVER="-${PVR_MICRO}"

# vala-panel needs 'cmake/FallbackVersion.cmake' to build but this is provided by vala-panel-appmenu #
#  thus creating a circular dependency, so copy it from the vala-panel-appmenu tarball #
VALA_PANEL_APPMENU_VER="0.7.6+dfsg1-2"

DESCRIPTION="Lightweight desktop panel"
HOMEPAGE="http://github.com/rilian-la-te/vala-panel"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}${UVER}.debian.tar.xz
	${UURL}/vala-panel-appmenu_${VALA_PANEL_APPMENU_VER}.debian.tar.xz"

LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+wnck +X"
RESTRICT="mirror"

RDEPEND="gui-libs/gtk-layer-shell
	>=x11-libs/gtk+-3.12.0:3
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	>=dev-libs/libpeas-1.2.0
	X? ( x11-libs/libX11 )
	wnck? ( >=x11-libs/libwnck-3.4.8:3 )"
DEPEND="${RDEPEND}
	dev-lang/vala:0.44
	dev-util/cmake
	dev-util/cmake-vala
	dev-lang/vala
	virtual/pkgconfig
	sys-devel/gettext"

GNOME2_ECLASS_GLIB_SCHEMAS="org.valapanel.gschema.xml"

src_prepare() {
	ubuntu-versionator_src_prepare
	vala_src_prepare
	export VALAC=$(type -P valac-0.44)
}

#src_install () {
#	meson_src_install
#}

pkg_postinst() {
	ubuntu-versionator_pkg_postinst
	gnome2_schemas_update
}
pkg_postrm() {
	gnome2_schemas_update
}
