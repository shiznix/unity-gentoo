# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils gnome2-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/c/${PN}"
URELEASE="utopic"
UVER_PREFIX="+14.10.20140806.2"

DESCRIPTION="Content sharing/picking infrastructure and service, designed to allow apps to securely and efficiently exchange content"
HOMEPAGE="https://launchpad.net/content-hub"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib
	dev-libs/libupstart-app-launch
	dev-libs/ubuntu-download-manager
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qttest:5
	dev-util/dbus-test-runner
	dev-util/lcov
	sys-libs/libnih[dbus]
	x11-libs/gsettings-qt
"

S=${WORKDIR}/${PN}-${PV}${UVER_PREFIX}
export PATH="/usr/$(get_libdir)/qt5/bin:${PATH}"	# Need to see QT5's qmake

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}

