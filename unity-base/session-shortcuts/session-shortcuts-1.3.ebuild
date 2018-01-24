# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="artful"
inherit ubuntu-versionator

UURL="mirror://unity/pool/universe/s/${PN}"
UVER=

DESCRIPTION="Allows shutdown, logout, and reboot from dash"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}${UVER}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-util/intltool
	sys-devel/gettext"

src_configure() {
	./build.sh
}

src_install() {
	insinto /usr/share/applications
	doins build/*.desktop
}
