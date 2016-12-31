# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit gnome2-utils qmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/q/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Qt plugins for Ubuntu Platform API (desktop)"
HOMEPAGE="https://launchpad.net/qtubuntu"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5[egl]
	dev-qt/qtsensors:5
	media-libs/fontconfig
	media-libs/freetype
	media-libs/mesa[egl,gles2]
	mir-base/mir
	mir-base/platform-api"

S="${WORKDIR}"

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
}
