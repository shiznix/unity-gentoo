# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="vivid"
inherit autotools base ubuntu-versionator

UURL="mirror://ubuntu/pool/main/libh/${PN}"
UVER_PREFIX="+git20131207+e452e83"

DESCRIPTION="Allows to run bionic-based HW adaptations in glibc systems"
HOMEPAGE="https://launchpad.net/libhybris"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="wayland"
RESTRICT="mirror"

DEPEND="dev-cpp/gflags
	dev-cpp/glog
	dev-libs/wayland
	dev-util/android-headers
	media-libs/mesa
	sys-apps/dbus"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="-j1"

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare

	cd "${S}/hybris"
	eautoreconf
}

src_configure() {
	cd "${S}/hybris"
	# Wayland is non-optional #
	econf \
		--enable-arch=x86 \
		--enable-wayland \
		--with-android-headers=/usr/include/android
}

src_compile() {
	cd "${S}/hybris"
	emake
}

src_install() {
	cd "${S}/hybris"
	emake DESTDIR="${ED}" install
	prune_libtool_files --modules

	# Remove unused and colliding files #
	rm -rfv "${ED}"usr/$(get_libdir)/pkgconfig/{wayland*,gles*,egl}.pc
	find "${ED}"usr/include \( ! -path "*include/hybris*" ! -path "*usr/include" \) -type d \
		-exec rm -rfv {} + || die

	# Install EGL libraries into correct path #
	dodir /usr/$(get_libdir)/libhybris-egl
	mv -f "${ED}"usr/$(get_libdir)/lib{EGL*,GLES*,wayland-egl*} \
		"${ED}"usr/$(get_libdir)/libhybris-egl || die
}
