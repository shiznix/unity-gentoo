# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="cosmic"
inherit autotools eutils ubuntu-versionator xdummy

UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"
GLEWMX="glew-1.13.0"

DESCRIPTION="Visual rendering toolkit for the Unity desktop"
HOMEPAGE="http://launchpad.net/nux"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz
	mirror://sourceforge/glew/${GLEWMX}.tgz"

LICENSE="GPL-3 LGPL-3"
SLOT="0/4"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples test"
RESTRICT="mirror"

# Build fails when >=media-libs/glew-2.0.0 is installed (see https://github.com/shiznix/unity-gentoo/issues/147) #
DEPEND="app-i18n/ibus
	dev-cpp/gtest
	dev-libs/boost:=
	dev-libs/glib:2
	dev-libs/libpcre
	dev-libs/libsigc++:2
	gnome-base/gnome-common
	media-libs/libpng:0
	sys-apps/pciutils
	unity-base/geis
	x11-base/xorg-proto
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXxf86vm
	x11-libs/pango
	doc? ( app-doc/doxygen )
	test? ( dev-cpp/gmock
		dev-cpp/gtest )"

S="${WORKDIR}"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff" # This needs to be applied for the debian/ directory to be present #
	ubuntu-versionator_src_prepare

	# Keep warnings as warnings, not failures #
	sed -e 's:-Werror ::g' \
		-i configure.ac
	eautoreconf

	sed \
		-e '/glew.lib.mx:/s|lib/$(LIB.SHARED.MX) ||' \
		-e "s:\(@libname@|\).*mx:-l\1${WORKDIR}/${GLEWMX}/lib/\$(LIB.STATIC.MX):" \
		-i ${WORKDIR}/${GLEWMX}/Makefile || die
}

src_configure() {
	emake -C ${WORKDIR}/${GLEWMX} glew.lib.mx AR="$(tc-getAR)" STRIP=true CC="$(tc-getCC)" POPT="${CFLAGS}"
	CXXFLAGS+=" -I${WORKDIR}/${GLEWMX}/include"
	PKG_CONFIG_PATH="${WORKDIR}/${GLEWMX}"

	use debug && \
		myconf="${myconf}
			--enable-debug=yes"
	use doc && \
		myconf="${myconf}
			--enable-documentation=yes"
	! use examples && \
		myconf="${myconf}
			--enable-examples=no"
	! use test && \
		myconf="${myconf}
			--enable-tests=no
			--enable-gputests=no"
	econf ${myconf}
}

src_test() {
	local XDUMMY_COMMAND="make check"
	xdummymake
}

src_install() {
	emake DESTDIR="${ED}" install || die
	sed -i 's:glewmx ::' "${ED}"/usr/$(get_libdir)/pkgconfig/* || die
	dosym /usr/libexec/nux/unity_support_test /usr/$(get_libdir)/nux/unity_support_test

	## Install gfx hardware support test script ##
	sed -e "s:xubuntu:xunity:g" \
		-e "s:/usr/lib/:/usr/$(get_libdir)/:g" \
			-i debian/50_check_unity_support
	exeinto /etc/X11/xinit/xinitrc.d/
	doexe debian/50_check_unity_support

	prune_libtool_files --modules
}
