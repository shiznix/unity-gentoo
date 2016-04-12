# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="wily"
inherit autotools eutils gnome2-utils ubuntu-versionator vala

UURL="mirror://unity/pool/main/u/${PN}"
UVER_PREFIX="+13.10.20130920"

DESCRIPTION="File lens for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-files"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	 ${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/dee:=
	dev-libs/libunity:="
DEPEND="${RDEPEND}
	dev-libs/libgee
	dev-libs/libzeitgeist
	>=gnome-extra/zeitgeist-0.9.14[datahub,fts]
	unity-base/unity
	unity-lenses/unity-lens-applications
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff" || die
	ubuntu-versionator_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
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
