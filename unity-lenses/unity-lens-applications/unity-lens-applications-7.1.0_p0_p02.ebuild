# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2 ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="trusty"
UVER_PREFIX="+13.10.20131011"

DESCRIPTION="Application lens for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-applications"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/dee:=
	dev-libs/libcolumbus:=
	dev-libs/libunity:="
DEPEND="${RDEPEND}
	dev-libs/libzeitgeist
	<dev-libs/xapian-1.3
	>=gnome-base/gnome-menus-3.8.0:3
	>=gnome-extra/zeitgeist-0.9.14[datahub,fts]
	sys-libs/db:5.1
	>=unity-base/unity-7.1.0
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
	# Alter source to work with Gentoo's sys-libs/db slots #
	sed -e 's:"db.h":"db5.1/db.h":g' \
		-i configure || die
	sed -e 's:-ldb$:-ldb-5.1:g' \
		-i src/* || die
	sed -e 's:<db.h>:<db5.1/db.h>:g' \
		-i src/* || die
}
