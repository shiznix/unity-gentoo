# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"

VALA_MIN_API_VERSION="0.20"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.04.15"

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
DEPEND="dev-lang/vala:0.18[vapigen]
	dev-libs/dee
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee
	dev-libs/libunity
	dev-libs/libzeitgeist
	|| ( ( net-libs/libsoup
		net-libs/libsoup-gnome )
		>net-libs/libsoup-2.42 )
	unity-base/unity
	unity-lenses/unity-lens-music
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}
