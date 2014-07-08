# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://github.com/darkxst/${PN}.git"

inherit autotools git-2

DESCRIPTION="Unity monitor display config"
HOMEPAGE="https://github.com/darkxst/displayconfig"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/glib:2
	>=gnome-base/gnome-desktop-3.10
	sys-power/upower
	x11-libs/gtk+:3
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${ED}" install

	insinto /etc/xdg/autostart
	doins "${FILESDIR}/unity-displayconfig.desktop"
}
