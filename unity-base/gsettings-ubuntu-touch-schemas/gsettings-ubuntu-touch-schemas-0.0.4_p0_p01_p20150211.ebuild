# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

URELEASE="vivid"
inherit autotools gnome2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/g/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="GSettings deskop-wide schemas for the Unity desktop"
HOMEPAGE="https://launchpad.net/gsettings-ubuntu-touch-schemas"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="sys-auth/polkit-pkla-compat"
DEPEND="gnome-base/dconf
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	econf --localstatedir=/var
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
}
