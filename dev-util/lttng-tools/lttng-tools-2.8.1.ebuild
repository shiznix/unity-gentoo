# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

URELEASE="yakkety"
inherit autotools-multilib eutils linux-info ubuntu-versionator
UVER="-1"

DESCRIPTION="Linux Trace Toolkit - next generation"
HOMEPAGE="http://lttng.org"
SRC_URI="http://lttng.org/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ust"
RESTRICT="mirror"

DEPEND="dev-libs/userspace-rcu[${MULTILIB_USEDEP}]
	dev-libs/popt[${MULTILIB_USEDEP}]
	ust? ( dev-util/lttng-ust[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

pkg_pretend() {
	if kernel_is -lt 2 6 27; then
		ewarn "${PN} require Linux kernel >= 2.6.27"
		ewarn "   pipe2(), epoll_create1() and SOCK_CLOEXEC are needed to run"
		ewarn "   the session daemon. There were introduce in the 2.6.27"
	fi
}

src_prepare() {
	ubuntu-versionator_src_prepare
	autotools-multilib_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable ust lttng-ust)
	)
	autotools-multilib_src_configure
}

src_install() {
	autotools-multilib_src_install
	prune_libtool_files --modules
}
