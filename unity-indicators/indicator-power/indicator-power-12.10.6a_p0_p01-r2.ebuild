# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

inherit cmake-utils gnome2-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/i/${PN}"
URELEASE="utopic"
UVER_PREFIX="+14.10.20140730"

DESCRIPTION="Indicator showing power state used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-power"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="gnome-extra/gnome-power-manager"
DEPEND="${RDEPEND}
	>=dev-libs/glib-2.40
	dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate-qt
	net-misc/url-dispatcher
	|| ( sys-power/upower sys-power/upower-pm-utils >=sys-apps/systemd-183 )
	unity-base/unity-settings-daemon"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="-j1"

src_prepare() {
	epatch "${FILESDIR}/sandbox_violations_fix.diff"

	# Make indicator start using XDG autostart #
	sed -e '/NotShowIn=/d' \
		-i data/indicator-power.desktop.in

	cmake-utils_src_prepare
}

src_install() {
	# Remove upstart jobs as we use XDG autostart desktop files to spawn indicators #
	rm -rf "${ED}usr/share/upstart"

	cmake-utils_src_install
}

pkg_preinst() {
        gnome2_schemas_savelist
}

pkg_postinst() {
        gnome2_schemas_update
}

pkg_postrm() {
        gnome2_schemas_update
}
