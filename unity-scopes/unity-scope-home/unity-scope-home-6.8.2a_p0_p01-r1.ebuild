# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils ubuntu-versionator vala

URELEASE="trusty"
UVER_PREFIX="+14.04.20131029.1"
UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"

DESCRIPTION="Home scope that aggregates results from multiple scopes for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-scope-home"
SRC_URI="${UURL}/${PN}_${PV}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/dee:=
	dev-libs/libunity:="
DEPEND="dev-libs/dee
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee
	dev-libs/libunity
	net-libs/libsoup-gnome
	net-libs/liboauth
	sys-apps/util-linux
	unity-base/unity
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}
