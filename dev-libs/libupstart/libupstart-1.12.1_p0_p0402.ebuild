# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils ubuntu-versionator

MY_PN="upstart"
MY_P="${MY_PN}_${PV}"
UURL="mirror://ubuntu/pool/main/u/${MY_PN}"
URELEASE="trusty-updates"

DESCRIPTION="Event-based replacement for the /sbin/init daemon."
HOMEPAGE="http://upstart.ubuntu.com/"
SRC_URI="${UURL}/${MY_PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+threads"
RESTRICT="mirror"

DEPEND="sys-devel/gettext
	sys-libs/libnih[dbus]
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	econf \
		$(use_enable threads threading)
}

src_install() {
	emake DESTDIR="${ED}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog HACKING NEWS README TODO

	# Only install libraries and includes #
	rm -rf "${ED}usr/share" "${ED}usr/sbin" "${ED}usr/bin" "${ED}etc"

	prune_libtool_files --modules
}
