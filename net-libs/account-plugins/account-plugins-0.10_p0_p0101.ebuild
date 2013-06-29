# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/a/${PN}"
URELEASE="raring-updates"
UVER_PREFIX="bzr13.03.26"

DESCRIPTION="Online account plugin for gnome-control-center used by the Unity desktop"
HOMEPAGE="https://launchpad.net/account-plugins"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	 ${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="unity-base/signon-keyring-extension
	unity-base/signon-plugin-oauth2
	x11-themes/unity-asset-pool"

DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=dev-util/intltool-0.40.1
	>=sys-devel/gettext-0.17
	unity-base/gnome-control-center-signon
	virtual/pkgconfig
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	epatch "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"

	eautoreconf
}

src_configure() {
	econf \
		--with-twitter-consumer-key="NGOB5S7sICsj6epjh0PhAw" \
		--with-twitter-consumer-secret="rbUEJCBEokMnGZd8bubd0QL2cSmoCjJeyiSJpnx3OM0" \
		--with-windows-live-client-id="00000000400D5635" \
		--with-foursquare-client-id="1I2UNJXPHNDZT3OPZOOA5LCPIUEUJFMKRXSF42UFCN1KXKTK" \
		--with-google-client-id="759250720802-4sii0me9963n9fdqdmi7cepn6ub8luoh.apps.googleusercontent.com" \
		--with-google-client-secret="juFngKUcuhB7IRQqHtSLavqJ" \
		--with-flickr-consumer-key="d87224f0b467093b2a87fd788d950e27" \
		--with-flickr-consumer-secret="4c7e48102c226509"
}
