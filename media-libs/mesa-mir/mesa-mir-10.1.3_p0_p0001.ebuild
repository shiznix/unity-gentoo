# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit autotools base eutils multilib multilib-minimal flag-o-matic \
	python-any-r1 toolchain-funcs ubuntu-versionator

OPENGL_DIR="xorg-x11"

MY_PN="mesa"
MY_PV="${PV}"
UURL="mirror://ubuntu/pool/main/m/${MY_PN}"
URELEASE="trusty-updates"

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="http://mesa3d.sourceforge.net/"
SRC_URI="${UURL}/${MY_PN}_${PV}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_PN}_${PV}${UVER_PREFIX}-${UVER}.diff.gz"

# The code is MIT/X11.
# GLES[2]/gl[2]{,ext,platform}.h are SGI-B-2.0
LICENSE="MIT SGI-B-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
RESTRICT="mirror"

INTEL_CARDS="i915 i965 ilo intel"
RADEON_CARDS="r100 r200 r300 r600 radeon radeonsi"
VIDEO_CARDS="${INTEL_CARDS} ${RADEON_CARDS} freedreno nouveau vmware"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS}
	bindist +classic debug +dri3 +egl +gallium gbm gles1 gles2 +llvm mir +nptl
	llvm-shared-libs opencl openvg osmesa pax_kernel pic r600-llvm-compiler
	selinux vdpau wayland xvmc xa kernel_FreeBSD"

REQUIRED_USE="
	llvm?   ( gallium )
	openvg? ( egl gallium )
	opencl? (
		gallium
		video_cards_r600? ( r600-llvm-compiler )
		video_cards_radeon? ( r600-llvm-compiler )
		video_cards_radeonsi? ( r600-llvm-compiler )
	)
	gles1?  ( egl )
	gles2?  ( egl )
	r600-llvm-compiler? ( gallium llvm || ( video_cards_r600 video_cards_radeonsi video_cards_radeon ) )
	wayland? ( egl gbm )
	xa?  ( gallium )
	video_cards_freedreno?  ( gallium )
	video_cards_intel?  ( || ( classic gallium ) )
	video_cards_i915?   ( || ( classic gallium ) )
	video_cards_i965?   ( classic )
	video_cards_ilo?    ( gallium )
	video_cards_nouveau? ( || ( classic gallium ) )
	video_cards_radeon? ( || ( classic gallium ) )
	video_cards_r100?   ( classic )
	video_cards_r200?   ( classic )
	video_cards_r300?   ( gallium )
	video_cards_r600?   ( gallium )
	video_cards_radeonsi?   ( gallium llvm )
	video_cards_vmware? ( gallium )
	${PYTHON_REQUIRED_USE}
"

LIBDRM_DEPSTRING=">=x11-libs/libdrm-2.4.49"
# keep correct libdrm and dri2proto dep
# keep blocks in rdepend for binpkg
RDEPEND="
	!<x11-base/xorg-server-1.7
	!<=x11-proto/xf86driproto-2.0.3
	abi_x86_32? ( !app-emulation/emul-linux-x86-opengl[-abi_x86_32(-)] )
	classic? ( app-admin/eselect-mesa )
	gallium? ( app-admin/eselect-mesa )
	>=app-admin/eselect-opengl-1.2.7
	dev-libs/expat[${MULTILIB_USEDEP}]
	gbm? ( virtual/udev[${MULTILIB_USEDEP}] )
	dri3? ( virtual/udev[${MULTILIB_USEDEP}] )
	>=x11-libs/libX11-1.3.99.901[${MULTILIB_USEDEP}]
	>=x11-libs/libxshmfence-1.1[${MULTILIB_USEDEP}]
	x11-libs/libXdamage[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	>=x11-libs/libxcb-1.9.2[${MULTILIB_USEDEP}]
	llvm? (
		video_cards_radeonsi? ( || (
			dev-libs/elfutils[${MULTILIB_USEDEP}]
			dev-libs/libelf[${MULTILIB_USEDEP}]
			) )
		video_cards_r600? ( || (
			dev-libs/elfutils[${MULTILIB_USEDEP}]
			dev-libs/libelf[${MULTILIB_USEDEP}]
			) )
		!video_cards_r600? (
			video_cards_radeon? ( || (
				dev-libs/elfutils[${MULTILIB_USEDEP}]
				dev-libs/libelf[${MULTILIB_USEDEP}]
				) )
		)
		llvm-shared-libs? ( >=sys-devel/llvm-2.9[${MULTILIB_USEDEP}] )
	)
	opencl? (
				app-admin/eselect-opencl
				dev-libs/libclc
			)
	vdpau? ( >=x11-libs/libvdpau-0.4.1[${MULTILIB_USEDEP}] )
	wayland? ( >=dev-libs/wayland-1.2.0[${MULTILIB_USEDEP}] )
	xvmc? ( >=x11-libs/libXvMC-1.0.6[${MULTILIB_USEDEP}] )
	${LIBDRM_DEPSTRING}[video_cards_freedreno?,video_cards_nouveau?,video_cards_vmware?,${MULTILIB_USEDEP}]
"
for card in ${INTEL_CARDS}; do
	RDEPEND="${RDEPEND}
		video_cards_${card}? ( ${LIBDRM_DEPSTRING}[video_cards_intel] )
	"
done

for card in ${RADEON_CARDS}; do
	RDEPEND="${RDEPEND}
		video_cards_${card}? ( ${LIBDRM_DEPSTRING}[video_cards_radeon] )
	"
done

for mesa_use in ${IUSE}; do
	MESA_USEDEPS+="${mesa_use}=,"
done
MESA_USEDEPS="${MESA_USEDEPS[@]/%,/}"
MESA_USEDEPS="${MESA_USEDEPS//+/}"

DEPEND="${RDEPEND}
	llvm? (
		>=sys-devel/llvm-2.9[${MULTILIB_USEDEP}]
		r600-llvm-compiler? ( sys-devel/llvm[video_cards_radeon] )
		video_cards_radeonsi? ( sys-devel/llvm[video_cards_radeon] )
	)
	opencl? (
				>=sys-devel/llvm-3.3-r1[video_cards_radeon,${MULTILIB_USEDEP}]
				>=sys-devel/clang-3.3[${MULTILIB_USEDEP}]
				>=sys-devel/gcc-4.6
	)
	=media-libs/mesa-${PVR}[${MESA_USEDEPS}]
	mir-base/mir
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	>=x11-proto/dri2proto-2.6[${MULTILIB_USEDEP}]
	dri3? (
		>=x11-proto/dri3proto-1.0[${MULTILIB_USEDEP}]
		>=x11-proto/presentproto-1.0[${MULTILIB_USEDEP}]
	)
	>=x11-proto/glproto-1.4.15-r1[${MULTILIB_USEDEP}]
	>=x11-proto/xextproto-7.0.99.1[${MULTILIB_USEDEP}]
	x11-proto/xf86driproto[${MULTILIB_USEDEP}]
	x11-proto/xf86vidmodeproto[${MULTILIB_USEDEP}]
	$(python_gen_any_dep 'dev-libs/libxml2[python,${PYTHON_USEDEP}]')
"

python_check_deps() {
	has_version --host-root "dev-libs/libxml2[python,${PYTHON_USEDEP}]"
}

# It is slow without texrels, if someone wants slow
# mesa without texrels +pic use is worth the shot
QA_EXECSTACK="usr/lib*/opengl/xorg-x11/lib/libGL.so*"
QA_WX_LOAD="usr/lib*/opengl/xorg-x11/lib/libGL.so*"

# Think about: ggi, fbcon, no-X configs

S="${WORKDIR}/Mesa-${PV}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	# workaround toc-issue wrt #386545
	use ppc64 && append-flags -mminimal-toc

	# warning message for bug 459306
	if use llvm && has_version sys-devel/llvm[!debug=]; then
		ewarn "Mismatch between debug USE flags in media-libs/mesa and sys-devel/llvm"
		ewarn "detected! This can cause problems. For details, see bug 459306."
	fi

	python-any-r1_pkg_setup
}

src_unpack() {
	default
}

src_prepare() {
	# Ubuntu patchset #
	epatch -p1 "${WORKDIR}/${MY_PN}_${MY_PV}-${UVER}.diff"	# This needs to be applied for the debian/ directory to be present #
	for patch in $(cat "${S}/debian/patches/series" | grep -v '#'); do
		epatch -p1 "${S}/debian/patches/${patch}" || die;
	done

	# relax the requirement that r300 must have llvm, bug 380303
	epatch "${FILESDIR}"/${MY_PN}-9.2-dont-require-llvm-for-r300.patch

	# fix for hardened pax_kernel, bug 240956
	epatch "${FILESDIR}"/glx_ro_text_segm.patch

	# Solaris needs some recent POSIX stuff in our case
	if [[ ${CHOST} == *-solaris* ]] ; then
		sed -i -e "s/-DSVR4/-D_POSIX_C_SOURCE=200112L/" configure.ac || die
	fi

	base_src_prepare

	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	local myconf

	if use classic; then
	# Configurable DRI drivers
		driver_enable swrast

	# Intel code
		driver_enable video_cards_i915 i915
		driver_enable video_cards_i965 i965
		if ! use video_cards_i915 && \
			! use video_cards_i965; then
			driver_enable video_cards_intel i915 i965
		fi

		# Nouveau code
		driver_enable video_cards_nouveau nouveau

		# ATI code
		driver_enable video_cards_r100 radeon
		driver_enable video_cards_r200 r200
		if ! use video_cards_r100 && \
				! use video_cards_r200; then
			driver_enable video_cards_radeon radeon r200
		fi
	fi

	if use egl; then
		myconf+="--with-egl-platforms=x11,mir$(use wayland && echo ",wayland")$(use gbm && echo ",drm") "
	fi

	if use gallium; then
		myconf+="
			$(use_enable llvm gallium-llvm)
			$(use_enable openvg)
			$(use_enable openvg gallium-egl)
			$(use_enable r600-llvm-compiler)
			$(use_enable vdpau)
			$(use_enable xa)
			$(use_enable xvmc)
		"
		gallium_enable swrast
		gallium_enable video_cards_vmware svga
		gallium_enable video_cards_nouveau nouveau
		gallium_enable video_cards_i915 i915
		gallium_enable video_cards_ilo ilo
		if ! use video_cards_i915 && \
			! use video_cards_i965; then
			gallium_enable video_cards_intel i915
		fi

		gallium_enable video_cards_r300 r300
		gallium_enable video_cards_r600 r600
		gallium_enable video_cards_radeonsi radeonsi
		if ! use video_cards_r300 && \
				! use video_cards_r600; then
			gallium_enable video_cards_radeon r300 r600
		fi

		gallium_enable video_cards_freedreno freedreno
		# opencl stuff
		if use opencl; then
			myconf+="
				$(use_enable opencl)
				--with-opencl-libdir="${EPREFIX}/usr/$(get_libdir)/OpenCL/vendors/mesa"
				--with-clang-libdir="${EPREFIX}/usr/lib"
				"
		fi
	fi

	# x86 hardened pax_kernel needs glx-rts, bug 240956
	if use pax_kernel; then
		myconf+="
			$(use_enable x86 glx-rts)
		"
	fi

	# build fails with BSD indent, bug #428112
	use userland_GNU || export INDENT=cat

	if ! multilib_is_native_abi; then
		myconf+="LLVM_CONFIG=${EPREFIX}/usr/bin/llvm-config.${ABI}"
	fi

	econf \
		--enable-dri \
		--enable-glx \
		--enable-shared-glapi \
		$(use_enable !bindist texture-float) \
		$(use_enable debug) \
		$(use_enable dri3) \
		$(use_enable egl) \
		$(use_enable gbm) \
		$(use_enable gles1) \
		$(use_enable gles2) \
		$(use_enable nptl glx-tls) \
		$(use_enable osmesa) \
		$(use_enable !pic asm) \
		$(use_with llvm-shared-libs) \
		--with-dri-drivers=${DRI_DRIVERS} \
		--with-gallium-drivers=${GALLIUM_DRIVERS} \
		PYTHON2="${PYTHON}" \
		${myconf}
}

multilib_src_install() {
	emake install DESTDIR="${D}"

	# Remove all files except those we need #
	find "${ED}" \
		\! -iname '*libEGL.so*' \
		\! -iname 'eglplatform.h' \
			-delete 2> /dev/null

	# Move libGL and others from /usr/lib to /usr/lib/opengl/blah/lib
	# because user can eselect desired GL provider.
	ebegin "Moving libGL and friends for dynamic switching"
		local x
		local gl_dir="/usr/$(get_libdir)/opengl/${OPENGL_DIR}/"
		dodir ${gl_dir}/{lib,extensions,include/GL}
		for x in "${ED}"/usr/$(get_libdir)/libEGL.{la,a,so*}; do
			if [ -f ${x} -o -L ${x} ]; then
				mv -f "${x}" "${ED}${gl_dir}"/lib \
					|| die "Failed to move ${x}"
			fi
		done
		for x in "${ED}"/usr/include/EGL; do
			if [ -d ${x} ]; then
				mv -f "${x}" "${ED}${gl_dir}"/include \
					|| die "Failed to move ${x}"
			fi
		done
	eend $?
}

multilib_src_install_all() {
	prune_libtool_files --all
	einstalldocs
}

pkg_postinst() {
	# Switch to the xorg implementation.
	echo
	eselect opengl set --use-old ${OPENGL_DIR}

	# switch to xorg-x11 and back if necessary, bug #374647 comment 11
	OLD_IMPLEM="$(eselect opengl show)"
	if [[ ${OPENGL_DIR}x != ${OLD_IMPLEM}x ]]; then
		eselect opengl set ${OPENGL_DIR}
		eselect opengl set ${OLD_IMPLEM}
	fi

	# Select classic/gallium drivers
	if use classic || use gallium; then
		eselect mesa set --auto
	fi

	# Switch to mesa opencl
	if use opencl; then
		eselect opencl set --use-old ${PN}
	fi

	# warn about patent encumbered texture-float
	if use !bindist; then
		elog "USE=\"bindist\" was not set. Potentially patent encumbered code was"
		elog "enabled. Please see patents.txt for an explanation."
	fi

	local using_radeon r_flag
	for r_flag in ${RADEON_CARDS}; do
		if use video_cards_${r_flag}; then
			using_radeon=1
			break
		fi
	done

	if [[ ${using_radeon} = 1 ]] && ! has_version media-libs/libtxc_dxtn; then
		elog "Note that in order to have full S3TC support, it is necessary to install"
		elog "media-libs/libtxc_dxtn as well. This may be necessary to get nice"
		elog "textures in some apps, and some others even require this to run."
	fi
}

# $1 - VIDEO_CARDS flag
# other args - names of DRI drivers to enable
# TODO: avoid code duplication for a more elegant implementation
driver_enable() {
	case $# in
		# for enabling unconditionally
		1)
			DRI_DRIVERS+=",$1"
			;;
		*)
			if use $1; then
				shift
				for i in $@; do
					DRI_DRIVERS+=",${i}"
				done
			fi
			;;
	esac
}

gallium_enable() {
	case $# in
		# for enabling unconditionally
		1)
			GALLIUM_DRIVERS+=",$1"
			;;
		*)
			if use $1; then
				shift
				for i in $@; do
					GALLIUM_DRIVERS+=",${i}"
				done
			fi
			;;
	esac
}
