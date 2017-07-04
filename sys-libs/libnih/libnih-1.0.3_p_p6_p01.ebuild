# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit versionator eutils autotools toolchain-funcs multilib flag-o-matic ubuntu-versionator

UURL="mirror://unity/pool/main/libn/${PN}"

DESCRIPTION="Light-weight 'standard library' of C functions"
HOMEPAGE="https://launchpad.net/libnih"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
        ${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dbus nls static-libs test +threads"

RDEPEND="dbus? ( dev-libs/expat sys-apps/dbus )"
DEPEND="sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-util/valgrind )"
RESTRICT="mirror"

src_prepare() {
	ubuntu-versionator_src_prepare
	epatch -p1 "${WORKDIR}/${MY_P}-${UVER}.diff"	# This needs to be applied for the debian/ directory to be present #
	epatch "${FILESDIR}"/${PN}-1.0.3-optional-dbus.patch
	eautoreconf
}

src_configure() {
	append-lfs-flags
	econf \
		$(use_with dbus) \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_enable threads) \
		$(use_enable threads threading)
}

src_install() {
	default

	# we need to be in / because upstart needs libnih
	gen_usr_ldscript -a nih $(use dbus && echo nih-dbus)
	use static-libs || rm "${ED}"/usr/$(get_libdir)/*.la
}
