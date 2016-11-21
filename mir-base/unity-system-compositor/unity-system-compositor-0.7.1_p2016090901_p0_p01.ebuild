# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{3_4,3_5} )

URELEASE="yakkety"
inherit cmake-utils python-r1 ubuntu-versionator

UURL="mirror://unity/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Compositor for Mir display server that switches graphics and input between running sessions"
HOMEPAGE="https://launchpad.net/unity-system-compositor"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="dev-libs/boost:=
	dev-libs/protobuf
	media-libs/mesa[egl,gbm,gles2]
	mir-base/mir:=
	<=dev-python/pillow-2.8.1[${PYTHON_USEDEP}]
	x11-base/xorg-server[mir]"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"	# This needs to be applied for the debian/ directory to be present #
	cmake-utils_src_prepare
}

src_configure() {
	# Disable tests as they fail to build #
	#	tests/unit-tests/test_mir_input_configuration.cpp:65:104
	#	required from here /usr/lib/gcc/x86_64-pc-linux-gnu/5.3.0/include/g++-v5/ext/new_allocator.h:120:4:
	#	error: invalid new-expression of abstract class type ‘testing::NiceMock<{anonymous}::MockInputDeviceHub>’
	mycmakeargs+=( -DCMAKE_INSTALL_SYSCONFDIR=/etc
			-DMIR_ENABLE_TESTS=OFF )
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	exeinto /usr/bin
	doexe debian/unity-system-compositor.sleep
}
