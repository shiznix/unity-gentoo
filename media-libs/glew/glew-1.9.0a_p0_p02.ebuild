# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit autotools multilib toolchain-funcs ubuntu-versionator base

DESCRIPTION="The OpenGL Extension Wrangler Library"
HOMEPAGE="http://glew.sourceforge.net/"

UURL="mirror://ubuntu/pool/main/g/${PN}"
URELEASE="trusty"
UVER_PREFIX=".is.1.8.0"

SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
        ${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
#KEYWORDS="alpha amd64 arm hppa ia64 ~mips ~ppc ~ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs"

RDEPEND="x11-libs/libXmu
	x11-libs/libXi
	virtual/glu
	virtual/opengl
	x11-libs/libXext
	x11-libs/libX11"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-1.8.0

pkg_setup() {
	myglewopts=(
		AR="$(tc-getAR)"
		STRIP=true
		CC="$(tc-getCC)"
		LD="$(tc-getCC) ${LDFLAGS}"
		M_ARCH=""
		LDFLAGS.EXTRA=""
		POPT="${CFLAGS}"
	)
}

src_prepare() {
        for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
                PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
        done

        base_src_prepare

	sed -i \
		-e '/INSTALL/s:-s::' \
		-e '/$(CC) $(CFLAGS) -o/s:$(CFLAGS):$(CFLAGS) $(LDFLAGS):' \
		Makefile || die

	if ! use static-libs ; then
		sed -i -e '/glew.lib:/s|lib/$(LIB.STATIC) ||' \
			-e '/glew.lib.mx:/s|lib/$(LIB.STATIC.MX) ||' \
			-e '/STRIP.* lib\/$(LIB.STATIC)/{N;d}' \
			-e '/STRIP.* lib\/$(LIB.STATIC.MX)/{N;d}' \
			Makefile || die
	fi

	# don't do stupid Solaris specific stuff that won't work in Prefix
	cp config/Makefile.linux config/Makefile.solaris || die
}

src_compile(){
	emake "${myglewopts[@]}"
}

src_install() {
	emake \
		GLEW_DEST="${ED}/usr" \
		LIBDIR="${ED}/usr/$(get_libdir)" \
		"${myglewopts[@]}" install.all

	dodoc README.txt TODO.txt
	use doc && dohtml doc/*
}

