# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
#VIRTUALX_REQUIRED="always"

URELEASE="wily"
inherit base cmake-utils gnome2-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/c/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Content sharing/picking service to allow apps to exchange content"
HOMEPAGE="https://launchpad.net/content-hub"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="!dev-libs/libupstart-app-launch
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qttest:5
	dev-qt/qdoc:5
	dev-util/dbus-test-runner
	dev-util/lcov
	net-libs/ubuntu-download-manager:=
	sys-apps/ubuntu-app-launch
	>=sys-libs/libapparmor-2.9.1
	sys-libs/libnih[dbus]
	x11-libs/gsettings-qt
	x11-libs/libnotify"

S=${WORKDIR}/${PN}-${PV}${UVER_PREFIX}
export QT_SELECT=5
unset QT_QPA_PLATFORMTHEME

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
