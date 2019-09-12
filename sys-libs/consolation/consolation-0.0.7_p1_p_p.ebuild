# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="eoan"
inherit systemd ubuntu-versionator

UVER="-${PVR_MICRO}"

DESCRIPTION="Console pointer support for copy-paste"
HOMEPAGE="https://launchpad.net/ubuntu/+source/consolation"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libevdev
	dev-libs/libinput"

src_prepare() {
	ubuntu-versionator_src_prepare
	sed -e 's:--no-daemon:--no-daemon --enable-tap --enable-dwt --set-speed=0.4:g' \
		-i consolation.service.in
}

src_install() {
	emake DESTDIR="${ED}" install
	insinto $(systemd_get_systemunitdir)
	doins consolation.service
}
