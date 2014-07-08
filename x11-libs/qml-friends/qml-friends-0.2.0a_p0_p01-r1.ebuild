# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base gnome2-utils qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/q/${PN}"
URELEASE="trusty"
UVER_PREFIX="+14.04.20140317"

DESCRIPTION="QML Bindings for the Friends library"
HOMEPAGE="https://launchpad.net/qml-friends"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/libfriends
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	x11-libs/dee-qt[qt5]"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
QT5_BUILD_DIR="${S}"

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
