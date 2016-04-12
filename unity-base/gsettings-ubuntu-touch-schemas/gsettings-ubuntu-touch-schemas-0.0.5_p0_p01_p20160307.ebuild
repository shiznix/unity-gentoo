# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="xenial"
inherit autotools gnome2-utils ubuntu-versionator

UURL="mirror://unity/pool/main/g/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="GSettings desktop-wide schemas for the Unity desktop"
HOMEPAGE="https://launchpad.net/gsettings-ubuntu-touch-schemas"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
#KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="sys-auth/polkit-pkla-compat"
DEPEND="${RDEPEND}
	gnome-base/dconf
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure() {
	econf --localstatedir=/var
}

src_install() {
	emake DESTDIR="${ED}" install
	find "${ED}" -name "*.pkla" -exec chown root:polkitd {} \;
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
