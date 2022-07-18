# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="jammy"
inherit eutils ubuntu-versionator xdg-utils

UVER_PREFIX="+17.10.${PVR_MICRO}"

DESCRIPTION="Unity desktop icon theme"
HOMEPAGE="https://launchpad.net/unity-asset-pool"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="x11-themes/adwaita-icon-theme
	x11-themes/hicolor-icon-theme"

BDEPEND="dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/unity/themes
	doins -r launcher/* panel/*

	insinto /usr/share/icons
	doins -r unity-icon-theme

	local DOCS=( COPYRIGHT README.txt )
	einstalldocs
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
