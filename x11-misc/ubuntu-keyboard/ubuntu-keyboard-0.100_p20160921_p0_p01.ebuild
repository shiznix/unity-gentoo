# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit gnome2-utils qmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Ubuntu on-screen keyboard data files"
HOMEPAGE="https://launchpad.net/ubuntu-keyboard"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="mirror"

DEPEND="app-i18n/anthy
	app-i18n/libpinyin
	app-i18n/maliit-framework
	app-text/hunspell
	app-text/presage
	dev-libs/libchewing
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	mir-base/mir:=
	mir-base/platform-api
	x11-libs/ubuntu-ui-toolkit
	test? ( dev-qt/qttest:5 )"

S="${WORKDIR}"

src_configure() {
	eqmake5 CONFIG+=$(usex test '' notests)
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
