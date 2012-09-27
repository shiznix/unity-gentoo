# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/light-themes/light-themes-0.1.9.2.ebuild,v 1.1 2012/06/16 13:53:08 sping Exp $

EAPI=4

DESCRIPTION="GTK2/GTK3 Ambiance and Radiance themes from Ubuntu"
HOMEPAGE="https://launchpad.net/light-themes"
SRC_URI="mirror://ubuntu/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-0ubuntu1.tar.gz"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk3"

DEPEND=""
RDEPEND="x11-themes/gtk-engines-murrine
	gtk3? ( x11-themes/gtk-engines-unico )"

S="${WORKDIR}/${PN}"

src_prepare() {
	cp -r Ambiance/ Ambiance-Gentoo || die
	cp -r Radiance/ Radiance-Gentoo || die
	sed -i -e 's/Ambiance/Ambiance-Gentoo/g' Ambiance-Gentoo/index.theme \
		Ambiance-Gentoo/metacity-1/metacity-theme-1.xml || die
	sed -i -e 's/Radiance/Radiance-Gentoo/g' Radiance-Gentoo/index.theme \
		Radiance-Gentoo/metacity-1/metacity-theme-1.xml || die
	sed -i -e 's/nselected_bg_color:#f07746/nselected_bg_color:#75755f5fbbbb/g' \
		Ambiance-Gentoo/gtk-2.0/gtkrc Ambiance-Gentoo/gtk-3.0/settings.ini \
		Radiance-Gentoo/gtk-2.0/gtkrc Radiance-Gentoo/gtk-3.0/settings.ini || die
	sed -i -e 's/nbg_color:#F2F1F0/nbg_color:#f2f2f1f1f0f0/g' \
		Ambiance-Gentoo/gtk-2.0/gtkrc Ambiance-Gentoo/gtk-3.0/settings.ini || die
}

src_install() {
	insinto /usr/share/themes
	doins -r Radiance* Ambiance*

	use gtk3 || {
		rm -R "${D}"/usr/share/themes/*/gtk-3.0 || die
	}
}
