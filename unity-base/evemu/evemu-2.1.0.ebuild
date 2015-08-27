# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

URELEASE="wily"
inherit autotools base eutils python-single-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/e/${PN}"
UVER="1build1"

DESCRIPTION="Event Emulation for the uTouch Stack"
HOMEPAGE="https://launchpad.net/evemu"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.xz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
