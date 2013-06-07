# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.20"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils flag-o-matic gnome2 ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/h/${PN}"
URELEASE="saucy"
UVER_PREFIX="daily13.06.05.1"

DESCRIPTION="Backend for the Unity HUD"
HOMEPAGE="https://launchpad.net/hud"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	unity-base/bamf:="
DEPEND="${RDEPEND}
	dev-db/sqlite:3
	>=dev-libs/glib-2.35.4
	dev-perl/XML-Parser
	gnome-base/dconf
	x11-libs/gtk+:3
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	epatch "${FILESDIR}/${PN}_strlen-fix.diff"
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}
