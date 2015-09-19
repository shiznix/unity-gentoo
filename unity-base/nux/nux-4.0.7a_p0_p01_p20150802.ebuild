# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="wily"
inherit autotools base eutils ubuntu-versionator xdummy

UURL="mirror://ubuntu/pool/main/n/${PN}"
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

DEPEND="app-i18n/ibus
	dev-cpp/gtest
	dev-libs/boost
	dev-libs/glib:2
	dev-libs/libpcre
	dev-libs/libsigc++:2
	gnome-base/gnome-common
	media-libs/glew:=
	media-libs/libpng:0
	sys-apps/pciutils
	>=sys-devel/gcc-4.7
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

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff" # This needs to be applied for the debian/ directory to be present #
	for patch in $(cat "debian/patches/series" | grep -v '#'); do
		PATCHES+=( "debian/patches/${patch}" )
	done
	base_src_prepare
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
	emake DESTDIR="${D}" install || die
	dosym /usr/libexec/nux/unity_support_test /usr/lib/nux/unity_support_test

	## Install gfx hardware support test script ##
	sed -e 's:xubuntu:xunity:g' \
		-i debian/50_check_unity_support
	exeinto /etc/X11/xinit/xinitrc.d/
	doexe debian/50_check_unity_support

	prune_libtool_files --modules
}
