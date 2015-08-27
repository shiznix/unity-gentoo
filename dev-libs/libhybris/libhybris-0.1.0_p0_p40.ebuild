# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="wily"
inherit autotools autotools-multilib base multilib ubuntu-versionator

UURL="mirror://ubuntu/pool/main/libh/${PN}"
UVER_PREFIX="+git20131207+e452e83"
UVER_SUFFIX="~gcc5.1"

DESCRIPTION="Allows to run bionic-based HW adaptations in glibc systems"
HOMEPAGE="https://launchpad.net/libhybris"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}${UVER_SUFFIX}.debian.tar.xz"

LICENSE="LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="wayland"
RESTRICT="mirror"

DEPEND="dev-cpp/gflags[${MULTILIB_USEDEP}]
	dev-cpp/glog[${MULTILIB_USEDEP}]
	dev-libs/wayland[${MULTILIB_USEDEP}]
	dev-util/android-headers[${MULTILIB_USEDEP}]
	media-libs/mesa[${MULTILIB_USEDEP}]
	sys-apps/dbus"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}/hybris"
MAKEOPTS="-j1"

src_prepare() {
	# Ubuntu patchset #
	cd "${WORKDIR}"
	for patch in $(cat "debian/patches/series" | grep -v \# ); do
		epatch "debian/patches/${patch}"
	done

	cd "${S}"
	eautoreconf
	ln -s /usr/include/android include/android	# ./configure usually does this, but pushd/popd used by multilib breaks it
}

src_configure() {
	# Wayland is non-optional #
	local myeconfargs=(
		--enable-arch=x86 \
		--enable-wayland \
		--with-android-headers=/usr/include/android
	)
	autotools-multilib_src_configure
}

src_compile() {
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
