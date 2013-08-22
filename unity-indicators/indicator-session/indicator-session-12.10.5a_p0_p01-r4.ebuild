# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils gnome2-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/i/${PN}"
URELEASE="saucy"
UVER_PREFIX="+13.10.20130821"

DESCRIPTION="Indicator showing session management, status and user switching used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-session"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="+help"
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	unity-base/unity-language-pack"
DEPEND="app-admin/system-config-printer-gnome
	dev-cpp/gtest
	>=dev-libs/glib-2.37.5
	dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate-qt
	>=gnome-extra/gnome-screensaver-3.6.0
	help? ( gnome-extra/yelp
		gnome-extra/gnome-user-docs
		unity-base/ubuntu-docs )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	# Fix schema errors and sandbox violations #
	epatch "${FILESDIR}/sandbox_violations_fix.diff"

	if ! use help || has nodoc ${FEATURES}; then
		epatch "${FILESDIR}/indicator-session_remove-help_saucy.patch"
	else
		sed -e 's:Ubuntu Help:Unity Help:g' \
			-i src/service.c
		sed -e 's:yelp:yelp help\:ubuntu-help:g' \
			-i src/backend-dbus/actions.c
	fi
}

pkg_preinst() {
	gnome2_schemas_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
