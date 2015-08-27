# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"
VALA_MIN_API_VERSION="0.22"
VALA_MAX_API_VERSION="0.22"

URELEASE="wily"
inherit autotools base bzr eutils gnome2 ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/i/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="System bluetooth indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-bluetooth"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"
#SRC_URI=

#EBZR_PROJECT="${PN}"
#EBZR_REPO_URI="lp:~robert-ancell/${PN}/bluez5"
#EBZR_REVISION="88"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=net-wireless/bluez-5
	media-sound/pulseaudio[bluetooth]"
DEPEND="${RDEPEND}
	dev-libs/glib:2
	dev-libs/libappindicator:=
	dev-libs/libdbusmenu:=
	dev-libs/libindicator:3=
	gnome-base/dconf
	net-misc/url-dispatcher
	unity-base/unity-control-center
	unity-indicators/ido:=
	x11-libs/gtk+:3
	$(vala_depend)"

S="${WORKDIR}/${P}"

#src_unpack() {
#	bzr_src_unpack
#}

src_prepare() {
#	bzr_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}

src_install() {
	gnome2_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"
}
