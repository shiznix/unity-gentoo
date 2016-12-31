# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit qmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/m/${PN}"
UVER_PREFIX="+git20151118+62bd54b"

DESCRIPTION="Maliit Input Method Framework"
HOMEPAGE="https://wiki.maliit.org/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+debug doc test wayland"
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	test? ( dev-qt/qttest:5 )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_configure() {
	export ENABLE_MULTITOUCH="false"
	export MALIIT_SERVER_ARGUMENTS="-software -bypass-wm-hint"
	export MALIIT_DEFAULT_PLUGIN="libmaliit-keyboard-plugin.so"
	eqmake5 CONFIG+="qt5-inputcontext enable-dbus-activation glib warn_off" \
		CONFIG+=$(usex debug debug) \
		CONFIG+=$(usex doc '' nodoc) \
		CONFIG+=$(usex test '' notests) \
		CONFIG+=$(usex wayland wayland)
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
}
