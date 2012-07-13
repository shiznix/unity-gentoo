# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/at-spi2-atk/at-spi2-atk-2.4.0.ebuild,v 1.1 2012/05/14 00:10:05 tetromino Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 virtualx

DESCRIPTION="Gtk module for bridging AT-SPI to Atk"
HOMEPAGE="http://live.gnome.org/Accessibility"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~arm ~hppa ~x86"
IUSE=""

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.4
	>=dev-libs/atk-2.1.0
	dev-libs/glib:2
	>=sys-apps/dbus-1
	x11-libs/libX11
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/at-spi-1.32.0-r1
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40
"

pkg_setup() {
	DOCS="AUTHORS NEWS README"
	# xevie is deprecated/broken since xorg-1.6/1.7
	G2CONF="${G2CONF} --enable-p2p"
}

src_prepare() {
	# disable teamspaces test since that requires Novell.ICEDesktop.Daemon
	epatch "${FILESDIR}/${PN}-2.0.2-disable-teamspaces-test.patch"

	# FIXME: droute test fails
#	sed -e 's:TESTS = droute-test\.*:TESTS = :' -i droute/Makefile.* ||
#		die "sed droute/Makefile.* failed"

	gnome2_src_prepare
}

src_test() {
	Xemake check
}
