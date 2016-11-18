# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

URELEASE="yakkety"
inherit autotools autotools-multilib eutils python-single-r1 ubuntu-versionator
UVER="-1"

DESCRIPTION="Linux Trace Toolkit - UST library"
HOMEPAGE="http://lttng.org"
SRC_URI="http://lttng.org/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE="examples"
RESTRICT="mirror"

DEPEND="dev-libs/userspace-rcu[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang .

	if ! use examples; then
		sed -i -e '/SUBDIRS/s:examples::' doc/Makefile.am || die
	fi
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-static=no
	)
	autotools-multilib_src_configure
}
