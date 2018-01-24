# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="artful"
inherit autotools eutils ubuntu-versionator xdummy

UURL="mirror://unity/pool/universe/n/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Visual rendering toolkit for the Unity desktop"
HOMEPAGE="http://launchpad.net/nux"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0/4"
#KEYWORDS="~amd64 ~x86"
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
	<media-libs/glew-2.0.0:=
	media-libs/libpng:0
	sys-apps/pciutils
	unity-base/geis
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXxf86vm
	x11-libs/pango
	x11-proto/dri2proto
	x11-proto/glproto
	doc? ( app-doc/doxygen )
	test? ( dev-cpp/gmock
		dev-cpp/gtest )"

S="${WORKDIR}"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff" # This needs to be applied for the debian/ directory to be present #
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure() {
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
	dosym /usr/libexec/nux/unity_support_test /usr/$(get_libdir)/nux/unity_support_test

	## Install gfx hardware support test script ##
	sed -e "s:xubuntu:xunity:g" \
		-e "s:/usr/lib/:/usr/$(get_libdir)/:g" \
			-i debian/50_check_unity_support
	exeinto /etc/X11/xinit/xinitrc.d/
	doexe debian/50_check_unity_support

	prune_libtool_files --modules
}
