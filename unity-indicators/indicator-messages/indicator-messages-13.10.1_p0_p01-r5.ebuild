# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
GNOME2_LA_PUNT="yes"

inherit autotools eutils flag-o-matic gnome2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/i/${PN}"
URELEASE="saucy"
UVER_PREFIX="+13.10.20130830.2"

DESCRIPTION="Indicator that collects messages that need a response used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-messages"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="!net-im/indicator-messages
	dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate-qt"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eautoreconf
	append-cflags -Wno-error
}
