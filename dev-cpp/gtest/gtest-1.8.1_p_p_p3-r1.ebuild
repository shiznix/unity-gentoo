# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

URELEASE="eoan"
inherit cmake-multilib python-single-r1 ubuntu-versionator

UVER="-${PVR_PL_MINOR}"
MY_PN="googletest"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="http://code.google.com/p/googletest/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}${UVER}.debian.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"
RESTRICT="mirror"

DEPEND="app-arch/unzip
	${PYTHON_DEPS}"
RDEPEND="!!dev-cpp/gmock
	!!<dev-cpp/gtest-1.8"

S="${WORKDIR}/${MY_PN}-release-1.8.1"


pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch -p1 "${FILESDIR}/gtest-gcc9_fix-signed-wchar.diff"
	ubuntu-versionator_src_prepare
	python_fix_shebang .
	cmake-utils_src_prepare
	sed -i -e '/set(cxx_base_flags /s:-Werror::' \
		googletest/cmake/internal_utils.cmake || die "sed failed!"
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_GMOCK=ON
		-DINSTALL_GTEST=ON
		-DBUILD_SHARED_LIBS=ON
		-Dgmock_build_tests=ON
		-Dgtest_build_tests=ON
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake-utils_src_configure
	MY_BUILD_DIR="${BUILD_DIR}"
}

multilib_src_install_all() {
	einstalldocs
	if use doc; then
		docinto googletest
		dodoc -r googletest/docs/.
		docinto googlemock
		dodoc -r googlemock/docs/.
	fi

	if use examples; then
		docinto examples
		dodoc googletest/samples/*.{cc,h}
	fi

	# Install GoogleTest source files + symlink for backwards compatibility #
	pushd googletest
		insinto /usr/src/googletest/googletest
		doins -r src cmake CMakeLists.txt
	popd
	dosym /usr/src/googletest/googletest /usr/src/gtest

	# Install GoogleMock source files + symlink for backwards compatibility #
	pushd googlemock
		insinto /usr/src/googletest/googlemock
		doins -r src cmake CMakeLists.txt test
	popd
	dosym /usr/src/googletest/googlemock /usr/src/gmock
}
