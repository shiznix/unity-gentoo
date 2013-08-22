# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
GNOME2_LA_PUNT="yes"

inherit autotools eutils flag-o-matic gnome2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/i/${PN}"
URELEASE="saucy"
UVER_PREFIX="+13.10.20130821"

DESCRIPTION="Indicator showing power state used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-power"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=dev-libs/glib-2.35.4
	dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate-qt
	>=gnome-base/gnome-settings-daemon-3.1.4
	sys-power/upower"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	append-cflags -Wno-error
	eautoreconf
}
