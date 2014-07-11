# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base gnome2-utils qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/f/${PN}"
URELEASE="utopic"
UVER_PREFIX="+14.10.20140506.1"

DESCRIPTION="Friends instant messaging client for the Unity desktop"
HOMEPAGE="https://launchpad.net/friends-app"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-qt/qtgraphicaleffects
	net-im/friends
	x11-libs/accounts-qml-module
	x11-libs/qml-friends
	x11-libs/u1db-qt
	x11-libs/ubuntu-ui-toolkit"
DEPEND="${RDEPEND}
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
QT5_BUILD_DIR="${S}"

src_configure() {
	/usr/$(get_libdir)/qt5/bin/qmake PREFIX=/usr
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	ubuntu-versionator_pkg_postinst
}
