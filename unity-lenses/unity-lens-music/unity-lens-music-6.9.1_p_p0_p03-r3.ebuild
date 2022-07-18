# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="jammy"
inherit autotools eutils ubuntu-versionator

UVER_PREFIX="+16.04"

DESCRIPTION="Music lens for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-music"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-db/sqlite:3
	dev-lang/vala:0.44
	dev-libs/dee:=
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee
	dev-libs/libunity:=
	gnome-base/gnome-menus:3
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	sys-libs/tdb
	unity-base/unity"
PDEPEND="|| ( media-sound/rhythmbox
		media-sound/banshee
		unity-scopes/smart-scopes[audacious]
		unity-scopes/smart-scopes[soundcloud] )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
export VALAC=$(type -P valac-0.44)

src_prepare() {
	PATCHES+=( "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff" )
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_install() {
	emake DESTDIR="${ED}" install

	dosym /usr/share/unity/icons \
		/usr/share/unity/6
}
