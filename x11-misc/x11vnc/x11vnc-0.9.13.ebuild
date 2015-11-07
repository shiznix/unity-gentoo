# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils ubuntu-versionator

URELEASE="wily"
UVER="1.2build1"

DESCRIPTION="A VNC server for real X displays"
HOMEPAGE="http://www.karlrunge.com/x11vnc/"
SRC_URI="mirror://sourceforge/libvncserver/${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi crypt dummy fbcon +jpeg ssl system-libvncserver threads tk xinerama +zlib"

RDEPEND="system-libvncserver? ( >=net-libs/libvncserver-0.9.7[threads=,jpeg=,zlib=] )
	!system-libvncserver? (
		zlib? ( sys-libs/zlib )
		jpeg? ( virtual/jpeg:0 )
	)
	dummy? ( x11-drivers/xf86-video-dummy )
	ssl? ( dev-libs/openssl )
	tk? ( dev-lang/tk )
	avahi? ( >=net-dns/avahi-0.6.4 )
	xinerama? ( x11-libs/libXinerama )
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libX11
	>=x11-libs/libXtst-1.1.0
	x11-libs/libXdamage
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-libs/libXt
	xinerama? ( x11-proto/xineramaproto )
	x11-proto/inputproto
	x11-proto/trapproto
	x11-proto/recordproto
	x11-proto/xproto
	x11-proto/xextproto"

pkg_setup() {
	if use avahi && ! use threads ; then
		ewarn "Non-native avahi support has been enabled."
		ewarn "Native avahi support can be enabled by also enabling the threads USE flag."
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-warnings.patch

	# Correct hard coded local prefix in Xdummy #
	sed -e 's:/usr/local:/usr:g' \
		-i x11vnc/misc/Xdummy
}

src_configure() {
	# --without-v4l because of missing video4linux 2.x support wrt #389079
	econf \
		$(use_with system-libvncserver) \
		$(use_with avahi) \
		$(use_with xinerama) \
		$(use_with ssl) \
		$(use_with ssl crypto) \
		$(use_with crypt) \
		--without-v4l \
		$(use_with jpeg) \
		$(use_with zlib) \
		$(use_with threads pthread) \
		$(use_with fbcon fbdev)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc x11vnc/{ChangeLog,README}

	# Remove include files, which conflict with net-libs/libvncserver
	rm -rf "${D}"/usr/include

	if use dummy; then
		exeinto /usr/bin
		doexe x11vnc/misc/Xdummy
	fi
}
