# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="wily"
inherit autotools eutils ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/u/${PN}"
UVER_PREFIX="+13.10.20130920"

DESCRIPTION="Video lens for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-video"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="!unity-lenses/unity-scope-video-remote
	dev-libs/dee:=
	dev-libs/libunity:="
DEPEND="dev-libs/dee
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee
	>=dev-libs/libunity-6.91.11
	dev-libs/libzeitgeist
	net-libs/libsoup
	net-libs/libsoup-gnome
	>=unity-base/unity-7.1.0
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}
