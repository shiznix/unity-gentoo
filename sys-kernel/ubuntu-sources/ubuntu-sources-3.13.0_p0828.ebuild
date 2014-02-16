# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit mount-boot versionator ubuntu-versionator

MY_PN="linux"
MY_PV="${PV%%[a-z]_p*}"
UURL="mirror://ubuntu/pool/main/l/${MY_PN}"
URELEASE="trusty"
UVER="${UVER##*[a-z]}"

DESCRIPTION="Ubuntu patched kernel sources"
HOMEPAGE="https://launchpad.net/ubuntu/+source/linux"
SRC_URI="${UURL}/${MY_PN}_${MY_PV}.orig.tar.gz
	${UURL}/${MY_PN}_${MY_PV}-${UVER}.diff.gz
	amd64? ( http://kernel.ubuntu.com/~kernel-ppa/configs/saucy/amd64-config.flavour.generic )
	x86? ( http://kernel.ubuntu.com/~kernel-ppa/configs/saucy/i386-config.flavour.generic )"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="binary"
RESTRICT="binchecks mirror strip"

DEPEND="binary? ( >=sys-kernel/genkernel-3.4.12.6-r4 )"
RDEPEND="binary? ( virtual/udev )"

S="${WORKDIR}/linux-$(get_version_component_range 1-2)"

pkg_setup() {
	case $ARCH in
		i386)
			defconfig_src=i386
			;;
		amd64)
			defconfig_src=amd64
			;;
		*)
			die "unsupported ARCH: $ARCH"
			;;
	esac
	defconfig_src="${DISTDIR}/${defconfig_src}-config.flavour.generic"
	unset ARCH; unset LDFLAGS # will interfere with Makefile if set
}

src_unpack() {
	unpack ${A}
}

src_prepare() {
	# Ubuntu patchset (don't use epatch so we can easily see what files get patched) #
	cat "${WORKDIR}/${MY_PN}_${MY_PV}-${UVER}.diff" | patch -p1 || die

	sed -i -e "s:^\(EXTRAVERSION =\).*:\1 ${EXTRAVERSION}:" Makefile || die
	sed	-i -e 's:#export\tINSTALL_PATH:export\tINSTALL_PATH:' Makefile || die
	rm -f .config >/dev/null

	# Ubuntu #
	install -d ${TEMP}/configs || die
	make -s mrproper || die "make mrproper failed"

	mv "${TEMP}/configs" "${S}" || die
}

src_compile() {
	! use binary && return
	install -d ${WORKDIR}/out/{lib,boot}
	install -d ${T}/{cache,twork}
	install -d $WORKDIR/build $WORKDIR/out/lib/firmware
	DEFAULT_KERNEL_SOURCE="${S}" CMD_KERNEL_DIR="${S}" genkernel ${GKARGS} \
		--no-save-config \
		--kernel-config="$defconfig_src" \
		--kernname="${PN}" \
		--build-src="$S" \
		--build-dst=${WORKDIR}/build \
		--makeopts="${MAKEOPTS}" \
		--firmware-dst=${WORKDIR}/out/lib/firmware \
		--cachedir="${T}/cache" \
		--tempdir="${T}/twork" \
		--logfile="${WORKDIR}/genkernel.log" \
		--bootdir="${WORKDIR}/out/boot" \
		--lvm \
		--luks \
		--iscsi \
		--module-prefix="${WORKDIR}/out" \
		all || die "genkernel failed"
}

src_install() {
	# copy sources into place #
	dodir /usr/src
	cp -a ${S} ${D}/usr/src/linux-${P} || die
	cd ${D}/usr/src/linux-${P}

	# prepare for real-world use and 3rd-party module building #
	make mrproper || die
	cp $defconfig_src .config || die
	yes "" | make oldconfig || die

	# if we didn't use genkernel, we're done. The kernel source tree is left in
	#  an unconfigured state - you can't compile 3rd-party modules against it yet
	use binary || return
	make prepare || die
	make scripts || die

	# Now the source tree is configured to allow 3rd-party modules to be built
	# against it, since we want that to work since we have a binary kernel built
	cp -a ${WORKDIR}/out/* ${D}/ || die "couldn't copy output files into place"

	# module symlink fixup #
	rm -f ${D}/lib/modules/*/source || die
	rm -f ${D}/lib/modules/*/build || die
	cd ${D}/lib/modules

	# module strip #
	find -iname *.ko -exec strip --strip-debug {} \;

	# back to the symlink fixup #
	local moddir="$(ls -d 2*)"
	ln -s /usr/src/linux-${P} ${D}/lib/modules/${moddir}/source || die
	ln -s /usr/src/linux-${P} ${D}/lib/modules/${moddir}/build || die
}

pkg_postinst() {
	[ ! -e ${ROOT}usr/src/linux ] && \
		ln -s linux-${P} ${ROOT}usr/src/linux
}
