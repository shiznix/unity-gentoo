# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

URELEASE="zesty"
inherit autotools autotools-multilib base multilib ubuntu-versionator

MY_PV="${PV}"
UURL="mirror://unity/pool/main/libh/${PN}"
UVER_PREFIX="+git20151016+6d424c9"

DESCRIPTION="Allows to run bionic-based HW adaptations in glibc systems"
HOMEPAGE="https://launchpad.net/libhybris"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}${UVER_SUFFIX}.debian.tar.xz"

LICENSE="LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-cpp/gflags[${MULTILIB_USEDEP}]
	dev-cpp/glog[${MULTILIB_USEDEP}]
	dev-libs/wayland[${MULTILIB_USEDEP}]
	dev-util/android-headers[${MULTILIB_USEDEP}]
	media-libs/mesa[${MULTILIB_USEDEP}]
	sys-apps/dbus"

S="${WORKDIR}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	ubuntu-versionator_src_prepare
	mv ${PN}-${MY_PV}${UVER_PREFIX}/hybris/* "${WORKDIR}"
	rm -rf ${PN}-${MY_PV}${UVER_PREFIX}
	eautoreconf
}

src_configure() {
	# Wayland is non-optional #
	local myeconfargs=(
		--enable-arch=x86 \
		--enable-wayland \
	)
	autotools-multilib_src_configure
	econf "${myeconfargs[@]}"	# Non-multilib ./configure run for 'make && make clean' command below
}

src_compile() {
	make && make clean	# Generate needed headers (egl/platforms/common/wayland-android-client-protocol.h)
	autotools-multilib_src_compile
}

src_install() {
	autotools-multilib_src_install
	prune_libtool_files --modules

	multilib_src_install() {
		# Remove unused and colliding files #
		rm -rfv "${ED}"usr/$(get_libdir)/pkgconfig/{wayland*,gles*,egl}.pc
		find "${ED}"usr/include \( ! -path "*include/hybris*" ! -path "*usr/include" \) -type d \
			-exec rm -rfv {} + || die

		# Install EGL libraries into correct path #
		dodir /usr/$(get_libdir)/libhybris-egl
		mv -f "${ED}"usr/$(get_libdir)/lib{EGL*,GLES*,wayland-egl*} \
			"${ED}"usr/$(get_libdir)/libhybris-egl || die
	}
	multilib_foreach_abi multilib_src_install
}
