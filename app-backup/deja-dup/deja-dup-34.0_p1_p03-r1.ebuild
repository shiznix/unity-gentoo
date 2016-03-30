# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="wily"
inherit cmake-utils ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/d/${PN}"

DESCRIPTION="Simple backup tool using duplicity back-end"
HOMEPAGE="https://launchpad.net/deja-dup/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+nautilus"
RESTRICT="mirror test"

COMMON_DEPEND="
	app-crypt/libsecret[vala]
	dev-libs/libdbusmenu:=
	dev-libs/libunity:=
	dev-libs/glib:2
	dev-libs/libpeas
	unity-base/unity-control-center
	x11-libs/gtk+:3
	x11-libs/libnotify
	app-backup/duplicity
	dev-libs/dbus-glib
	nautilus? ( gnome-base/nautilus )"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gvfs[fuse]"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-perl/Locale-gettext
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext
	$(vala_depend)"

src_prepare() {
	ubuntu-versionator_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=(-DCMAKE_INSTALL_SYSCONFDIR=/etc
		-DVALA_COMPILER=$VALAC
		-DVAPI_GEN=$VAPIGEN)
	cmake-utils_src_configure
}
