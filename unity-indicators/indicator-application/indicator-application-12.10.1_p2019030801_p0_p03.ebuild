# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="jammy"
inherit autotools eutils flag-o-matic ubuntu-versionator

UVER_PREFIX="+19.04.${PVR_MICRO}"

DESCRIPTION="Application indicators used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-application"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libappindicator:=
	dev-libs/libdbusmenu:="

S="${WORKDIR}"

src_prepare() {
	eapply "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"
	ubuntu-versionator_src_prepare
	# Fix desktop file installation location #
	sed 's:$(pkgdatadir)/upstart/xdg/autostart:$(datadir)/upstart/xdg/autostart:g' \
		-i data/upstart/Makefile.am
	eautoreconf

	# src/application-service-appstore.c uses 'app->status = APP_INDICATOR_STATUS_PASSIVE' to remove the app from panel #
	#	However some SNI tray icons always report their status as 'Passive' and so never show up, or get removed when they shouldn't be
	#	Examples are:
	#	KTorrent (never shows up)
	#	Quassel (disappears when disconnected from it's core)
	#	  Quassel also requires patching to have a complete base set of SNI items (profiles/${URELEASE}/patches/net-irc/quassel/SNI-systray_fix.patch)
	eapply "${FILESDIR}/sni-systray_show-passive_v2.diff"
}

src_install() {
	emake DESTDIR="${ED}" install
	prune_libtool_files --modules
}
