# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="xenial"
inherit autotools eutils gnome2-utils ubuntu-versionator vala

UURL="mirror://unity/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Application lens for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-applications"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/dee:=
	dev-libs/libcolumbus:=
	dev-libs/libunity:=
	dev-libs/libzeitgeist
	<dev-libs/xapian-1.3
	gnome-base/gnome-menus:3
	gnome-extra/zeitgeist[datahub,fts]
	sys-libs/db:5.3
	unity-base/unity
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
	# Alter source to work with Gentoo's sys-libs/db slots #
	sed -e 's:"db.h":"db5.3/db.h":g' \
		-i configure || die
	sed -e 's:-ldb$:-ldb-5.3:g' \
		-i src/* || die
	sed -e 's:<db.h>:<db5.3/db.h>:g' \
		-i src/* || die
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
