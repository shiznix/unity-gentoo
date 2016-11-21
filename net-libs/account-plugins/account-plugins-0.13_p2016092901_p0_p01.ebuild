# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit autotools eutils gnome2-utils ubuntu-versionator vala

UURL="mirror://unity/pool/main/a/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Online account plugin for gnome-control-center used by the Unity desktop"
HOMEPAGE="https://launchpad.net/account-plugins"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

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
	dev-util/intltool
	sys-devel/gettext
	unity-base/gnome-control-center-signon
	virtual/pkgconfig
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto
	$(vala_depend)"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	vala_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		--enable-qml-plugins \
		--with-twitter-consumer-key="NGOB5S7sICsj6epjh0PhAw" \
		--with-twitter-consumer-secret="rbUEJCBEokMnGZd8bubd0QL2cSmoCjJeyiSJpnx3OM0" \
		--with-windows-live-client-id="00000000400D5635" \
		--with-facebook-client-id="271112146382618" \
		--with-foursquare-client-id="1I2UNJXPHNDZT3OPZOOA5LCPIUEUJFMKRXSF42UFCN1KXKTK" \
		--with-google-client-id="759250720802-4sii0me9963n9fdqdmi7cepn6ub8luoh.apps.googleusercontent.com" \
		--with-google-client-secret="juFngKUcuhB7IRQqHtSLavqJ" \
		--with-flickr-consumer-key="d87224f0b467093b2a87fd788d950e27" \
		--with-flickr-consumer-secret="4c7e48102c226509" \
		--with-linkedin-consumer-key="34gnzrg96iq5" \
		--with-linkedin-consumer-secret="BazRki2LE8eZtcqh" \
		--with-instagram-client-id="01c3df41a2274a14882adea8e8ebbd46" \
		--with-instagram-client-secret="4751ccdc39c648719ea83cfb1c866c26"
}

src_install() {
	emake DESTDIR="${ED}" install
	prune_libtool_files --modules
}
