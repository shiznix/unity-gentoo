# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="eoan"
inherit ubuntu-versionator

UVER=

DESCRIPTION="Default settings for Ubuntu MATE"
HOMEPAGE="https://github.com/ubuntu-mate/ubuntu-mate-settings"
SRC_URI="${UURL}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/glib:2
	gnome-base/gvfs"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	# Remove attempting to launch 'ubuntu-mate-welcome' as is a frontend to 'apt' package management #
	sed -e '/ubuntu-mate-welcome/d' \
		-i usr/lib/ubuntu-mate/ubuntu-mate-settings-overlay

	# mate-extra/caja-dropbox is a seperate package on Gentoo #
	rm -f usr/bin/caja-dropbox-autostart

	ubuntu-versionator_src_prepare
}

src_install() {
	doins -r {etc,usr}
	insinto /etc/X11/xinit/xinitrc.d
	doins etc/X11/Xsession.d/80mate-environment

	# Delete some files that are only useful on Ubuntu #
	rm -rf "${ED}etc/apport"
	rm -rf "${ED}etc/X11/Xsession.d"
	rm -rf "${ED}usr/share/ubiquity"

	# Respect Gentoo MATE defaults and don't collide with mate-base/mate-session-manager #
	rm -f "${ED}usr/share/mate/applications/defaults.list"

	# Remove all autostart *.desktop files except those we need #
	find "${ED}usr/share/mate/autostart/" -type f \
		! -name 'ubuntu-mate-settings-overlay.desktop' \
		! -name 'mate-hud.desktop' \
			-delete || die
}
