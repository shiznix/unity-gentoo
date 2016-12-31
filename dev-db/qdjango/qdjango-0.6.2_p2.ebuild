# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="yakkety"
inherit multilib qmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/q/${PN}"
UVER="-${PVR_MICRO}"

DESCRIPTION="QML Bindings for GSettings"
HOMEPAGE="https://launchpad.net/gsettings-qt"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qtsql:5
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest:5 )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
QT5_BUILD_DIR="${S}"
export PATH="/usr/$(get_libdir)/qt5/bin:${PATH}"	# Need to see QT5's qmake

src_prepare() {
	ubuntu-versionator_src_prepare
	epatch -p1 "${FILESDIR}/fix_gcc6_ftbfs.patch"
	use examples || \
		sed -e 's:examples::g' \
			-i qdjango.pro
	use test || \
		sed -e 's:tests::g' \
			-i qdjango.pro
}

src_configure() {
	eqmake5 PREFIX=/usr
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
}
