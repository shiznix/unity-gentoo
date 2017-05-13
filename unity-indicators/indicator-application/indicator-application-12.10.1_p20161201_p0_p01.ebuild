# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit autotools eutils flag-o-matic ubuntu-versionator

UURL="mirror://unity/pool/main/i/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Application indicators used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-application"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libappindicator:=
	dev-libs/libdbusmenu:=
	dev-libs/libindicate-qt"

S="${WORKDIR}"

src_prepare() {
	# Fix desktop file installation location #
	sed 's:$(pkgdatadir)/upstart/xdg/autostart:$(datadir)/upstart/xdg/autostart:g' \
		-i data/upstart/Makefile.am
	ubuntu-versionator_src_prepare
	eautoreconf
	append-cflags -Wno-error

	# src/application-service-appstore.c uses 'app->status = APP_INDICATOR_STATUS_PASSIVE' to remove the app from panel #
	#	However some SNI tray icons always report their status as 'Passive' and so never show up, or get removed when they shouldn't be
	#	Examples are:
	#	KTorrent (never shows up)
	#	Quassel (disappears when disconnected from it's core)
	#	  Quassel also requires patching to have a complete base set of SNI items (profiles/${URELEASE}/patches/net-irc/quassel/SNI-systray_fix.patch)
	epatch -p1 "${FILESDIR}/sni-systray_show-passive_v2.diff"
}

src_install() {
	emake DESTDIR="${ED}" install
	prune_libtool_files --modules
}
