# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.20"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils gnome2 ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.04.18~13.04"

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
	>=gnome-base/gnome-menus-3.0.1-r1:0
	>=gnome-extra/zeitgeist-0.9.14[datahub,fts]
	sys-libs/db:5.1
	unity-base/unity
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
