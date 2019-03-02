# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="cosmic"
inherit autotools eutils flag-o-matic ubuntu-versionator

UVER_PREFIX="+14.04.20140115"

DESCRIPTION="Miscellaneous modules for the Unity desktop"
HOMEPAGE="https://launchpad.net/libunity-misc"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/4.1.0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

DEPEND="x11-libs/gtk+:3
	x11-libs/libXfixes
	dev-util/gtk-doc-am
	dev-util/gtk-doc"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	epatch "${FILESDIR}/libunity-misc-4.0.5b-deprecated-api.patch"

	# Make docs optional #
	! use doc && \
		sed -e 's:unity-misc doc:unity-misc:' \
			-i Makefile.am
	eautoreconf
	append-cflags -Wno-error
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
