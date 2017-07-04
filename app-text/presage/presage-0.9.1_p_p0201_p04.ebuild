# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python2_7 )

URELEASE="zesty"
inherit autotools eutils python-single-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/p/${PN}"

DESCRIPTION="The intelligent predictive text entry system"
HOMEPAGE="http://presage.sourceforge.net"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"
RESTRICT="mirror"

RDEPEND="app-text/dos2unix
	examples? ( sys-libs/ncurses )"
DEPEND="${RDEPEND}
	dev-db/sqlite:3
	dev-lang/swig
	dev-libs/tinyxml
	dev-python/dbus-python
	sys-apps/help2man
	x11-libs/gtk+:2
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc documentation)
		$(use_enable examples curses)
		$(use_enable test)
	)
	econf ${myeconfargs}
}
