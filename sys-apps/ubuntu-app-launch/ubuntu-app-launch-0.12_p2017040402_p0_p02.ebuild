# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Session init system job for launching applications"
HOMEPAGE="https://launchpad.net/ubuntu-app-launch"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="app-admin/cgmanager
	dev-libs/glib:2
	dev-libs/gobject-introspection
	dev-libs/json-glib
	dev-libs/libzeitgeist
	dev-libs/properties-cpp
	dev-util/lttng-tools
	dev-util/dbus-test-runner
	mir-base/mir:=
	net-misc/curl
	sys-apps/click
	sys-apps/dbus
	sys-apps/libertine
	sys-apps/upstart
	sys-libs/libnih[dbus]"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare

	# Fix incorrect installation path for ubuntu-app-test binary #
	sed -e 's:{CMAKE_INSTALL_FULL_BINDIR}/app-test:{CMAKE_INSTALL_FULL_BINDIR}:g' \
		-i ubuntu-app-test/src/CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	! use test && \
		mycmakeargs+=(-Denable_tests=OFF)
	cmake-utils_src_configure
}
