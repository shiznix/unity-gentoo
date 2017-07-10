# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit eutils multilib multilib-minimal ubuntu-versionator versionator

UURL="mirror://unity/pool/main/a/${PN}"

DESCRIPTION="Android Platform Headers from AOSP releases"
HOMEPAGE="https://source.android.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	ubuntu-versionator_src_prepare
}

src_configure() {
	:	# Do nothing
}

src_compile() {
	:	# Do nothing
}

src_install() {
	for dir in *; do
		insinto /usr/include/android-${dir}
		doins -r ${dir}/*
	done

	# Yakkety uses android-19 as the system selected android headers version #
	dosym /usr/include/android-19 /usr/include/android

	multilib_src_install() {
		insinto "/usr/$(get_libdir)/pkgconfig"
		doins "${WORKDIR}"/debian/android-headers*pc
	}
	multilib_foreach_abi multilib_src_install
}
