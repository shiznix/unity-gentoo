# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="wily"
inherit eutils multilib multilib-minimal ubuntu-versionator

UURL="mirror://unity/pool/main/a/${PN}"
UVER_PREFIX="2"

DESCRIPTION="Android Platform Headers from AOSP releases"
HOMEPAGE="https://source.android.com/"
SRC_URI="${UURL}/${MY_P}-${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}-${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}-${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
}

src_configure() {
	:	# Do nothing
}

src_compile() {
	:	# Do nothing
}

src_install(){
	insinto /usr/include/android
	doins -r *

	multilib_src_install() {
		insinto "/usr/$(get_libdir)/pkgconfig"
		doins "${WORKDIR}/debian/android-headers.pc"
	}
	multilib_foreach_abi multilib_src_install
}
