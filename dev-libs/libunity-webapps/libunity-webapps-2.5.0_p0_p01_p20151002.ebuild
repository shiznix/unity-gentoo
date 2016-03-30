# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="wily"
inherit autotools eutils gnome2-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/libu/${PN}"
UVER_PREFIX="~+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Webapps integration with the Unity desktop"
HOMEPAGE="https://launchpad.net/libunity-webapps"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0/0.0.0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

DEPEND="app-admin/packagekit-base
	app-misc/geoclue:0
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/gobject-introspection
	dev-libs/json-glib
	dev-libs/libdbusmenu:=
	dev-libs/libindicate[gtk,introspection]
	dev-libs/libunity:=
	dev-util/intltool
	net-libs/libsoup
	net-libs/telepathy-glib
	x11-libs/gtk+:3
	unity-indicators/indicator-messages
	x11-libs/libnotify
	x11-libs/libwnck:3"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--libexecdir=/usr/lib/libunity-webapps
}

src_install() {
	emake DESTDIR="${ED}" install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"

	# Don't use ubuntu-webapps-update-index as we don't use apt package manager #
	cat <<-EOF > "${ED}usr/bin/ubuntu-webapps-update-index"
	#!/bin/sh
	/bin/false
	EOF
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	elog "Unity webapps will only currently work if your default browser"
	elog "is set to either Firefox or Chromium"
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postrm() {
	gnome2_schemas_update
}
