# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="wily"
inherit ubuntu-versionator

UURL="mirror://ubuntu/pool/main/n/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Icons for on-screen-display notification agent"
HOMEPAGE="http://launchpad.net/notify-osd"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-misc/notify-osd"
DEPEND=""

RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_install() {
	emake DESTDIR="${D}" install || die

	# Source: debian/notify-osd-icons.links
	local path=/usr/share/notify-osd/icons/Humanity/scalable/status
	dosym notification-battery-000.svg ${path}/notification-battery-empty.svg
	dosym notification-battery-020.svg ${path}/notification-battery-low.svg
}
