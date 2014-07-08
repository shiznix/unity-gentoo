# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base gnome2-utils qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="trusty"
UVER_PREFIX="+14.04.20140408.1"

DESCRIPTION="Qt Components for the Unity desktop - QML plugin"
HOMEPAGE="https://launchpad.net/ubuntu-ui-toolkit"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	 ${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"
RESTRICT="mirror"

RDEPEND="dev-qt/qtfeedback
	x11-libs/unity-action-api"
DEPEND="${RDEPEND}
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtjsbackend:5
	dev-qt/qtnetwork:5
	dev-qt/qtpim:5
	dev-qt/qtsvg:5
	media-gfx/thumbnailer"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="${MAKEOPTS} -j1"
QT5_BUILD_DIR="${S}"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"

	# Docs don't build - full of segfaults and incorrect paths #
	sed -e '/documentation\/documentation.pri/d' \
		-i ubuntu-sdk.pro
	qt5-build_src_prepare
}

src_install() {
	qt5-build_src_install

	use examples || \
		rm -rf "${ED}usr/lib/ubuntu-ui-toolkit/examples"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
}
