# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="disco"
inherit ubuntu-versionator
UVER=

DESCRIPTION="Default audio theme for the Unity"
HOMEPAGE="https://launchpad.net/ubuntu-sounds"
SRC_URI="${UURL}/${MY_P}.tar.xz"

LICENSE="CC-BY-NC-SA-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
RESTRICT="binchecks mirror strip"

src_install() {
	insinto /usr/share/sounds
	doins -r ubuntu
}
