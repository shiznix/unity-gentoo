# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools base ubuntu-versionator

UURL="mirror://ubuntu/pool/main/libh/${PN}"
URELEASE="saucy"
UVER_PREFIX="+git20130606+c5d897a"

DESCRIPTION="Common library that contains the Android linker and custom hooks"
HOMEPAGE="https://launchpad.net/libhybris"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-cpp/gflags
	dev-cpp/glog
	media-libs/mesa[hybris]
	sys-apps/dbus"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

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
	econf \
		--enable-arch=x86 \
		--enable-mesa \
		--enable-alinker=jb
}

src_compile() {
	cd "${S}/hybris"
	emake
}

src_install() {
	cd "${S}/hybris"
	emake DESTDIR="${ED}" install

	## Integrate with media-libs/mesa ##
	ebegin "Moving GL libs and headers for dynamic switching"
		local x
		local gl_dir="/usr/$(get_libdir)/opengl/${OPENGL_DIR}/"
		dodir ${gl_dir}/{lib,extensions,include/GL}

		for x in "${ED}"/usr/$(get_libdir)/lib{EGL,GL*,OpenVG}.{la,a,so*}; do
			if [ -f ${x} -o -L ${x} ]; then 
				mv -f "${x}" "${ED}${gl_dir}"/lib \
					|| die "Failed to move ${x}"
			fi
		done
		for x in "${ED}"/usr/include/GL/{gl.h,glx.h,glext.h,glxext.h}; do
			if [ -f ${x} -o -L ${x} ]; then 
				mv -f "${x}" "${ED}${gl_dir}"/include/GL \
					|| die "Failed to move ${x}"
			fi
		done
		for x in "${ED}"/usr/include/{EGL,GLES*,VG,KHR}; do
			if [ -d ${x} ]; then
				mv -f "${x}" "${ED}${gl_dir}"/include \
					|| die "Failed to move ${x}"
			fi
		done
	eend $?
}
