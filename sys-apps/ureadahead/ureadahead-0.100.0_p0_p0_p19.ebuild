# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="wily"
inherit autotools eutils linux-info systemd ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
UVER="19"

DESCRIPTION="Ureadahead - Read files in advance during boot"
HOMEPAGE="https://launchpad.net/ureadahead"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="sys-libs/libnih
	sys-apps/util-linux
	sys-fs/e2fsprogs
	|| ( sys-kernel/ubuntu-sources:*
		sys-kernel/zen-sources:* )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

CONFIG_CHECK="~FTRACE ~DEBUG_FS"

src_prepare() {
	# Ubuntu patchset #
	epatch -p1 "${WORKDIR}/${MY_P}-${UVER}.diff" || die
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure() {
	econf --sbindir=/sbin
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -r "${D}/etc/init"
	newinitd "${FILESDIR}"/ureadahead.initd ureadahead
	systemd_dounit "${FILESDIR}/${PN}-collect.service" "${FILESDIR}/${PN}-replay.service"
	keepdir /var/lib/ureadahead
}

pkg_postinst() {
	ubuntu-versionator_pkg_postinst
	elog "To enable ureadahead, as root do:"
	elog "systemctl enable ureadahead-collect.service"
	elog
	elog "If systemd-readahead is enabled, it is recommended it be disabled when using ureadahead"
	elog
	elog "To disable systemd-readahead, as root do:"
	elog "systemctl disable systemd-readahead-collect.service systemd-readahead-replay.service"
}
