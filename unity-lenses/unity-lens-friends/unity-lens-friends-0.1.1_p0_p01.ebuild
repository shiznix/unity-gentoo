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
UVER_PREFIX="bzr13.04.12"

DESCRIPTION="Friends lens for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-friends"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/dee:=
	dev-libs/libunity:=
	net-im/friends"
DEPEND="${RDEPEND}
	dev-libs/libaccounts-glib
	dev-libs/libfriends
	dev-libs/glib:2
	dev-libs/libgee
	unity-base/unity
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}
