# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit ubuntu-versionator

UURL="mirror://unity/pool/main/u/${PN}"

DESCRIPTION="Default audio theme for the Unity"
HOMEPAGE="https://launchpad.net/ubuntu-sounds"
SRC_URI="${UURL}/${MY_P}.tar.gz"

LICENSE="CC-BY-NC-SA-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
RESTRICT="binchecks mirror strip"

src_install() {
	insinto /usr/share/sounds
	doins -r ubuntu
}
