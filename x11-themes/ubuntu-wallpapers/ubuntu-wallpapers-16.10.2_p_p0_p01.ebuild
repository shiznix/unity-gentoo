# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit ubuntu-versionator

UURL="mirror://unity/pool/main/u/${PN}"

DESCRIPTION="Ubuntu wallpapers"
HOMEPAGE="https://launchpad.net/ubuntu-wallpapers"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="CC-BY-SA-3.0"
#KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""
RESTRICT="mirror"

src_compile() { :; }
src_test() { :; }

src_install() {
	insinto /usr/share/backgrounds
	doins *.jpg *.png

	insinto /usr/share/backgrounds/contest
	doins contest/*.xml

	for i in *.xml.in; do
		insinto /usr/share/gnome-background-properties
		newins ${i} ${i/.in/}
	done

	dodoc AUTHORS
}
