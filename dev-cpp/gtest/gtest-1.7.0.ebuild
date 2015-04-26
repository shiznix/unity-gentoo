# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 autotools-multilib ubuntu-versionator

UURL="mirror://ubuntu/pool/main/g/${PN}"
URELEASE="vivid"
UVER="3"

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="http://code.google.com/p/googletest/"
#SRC_URI="http://googletest.googlecode.com/files/${P}.zip"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples static-libs"
RESTRICT="mirror"

DEPEND="app-arch/unzip"
RDEPEND=""

PATCHES=(
	"${FILESDIR}/configure-fix-pthread-linking.patch" #371647
)

AUTOTOOLS_AUTORECONF="1"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done

	sed -i -e "s|/tmp|${T}|g" test/gtest-filepath_test.cc || die
	sed -i -r \
		-e '/^install-(data|exec)-local:/s|^.*$|&\ndisabled-&|' \
		Makefile.am || die
	autotools-multilib_src_prepare
	python_fix_shebang .
	multilib_copy_sources
}

src_configure() {
	multilib_parallel_foreach_abi gtest_src_configure
}

src_install() {
	autotools-multilib_src_install
	multilib_for_best_abi gtest-config_install

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins samples/*.{cc,h}
	fi

	insinto /usr/src/gtest
	doins -r src cmake CMakeLists.txt
}

gtest_src_configure() {
	ECONF_SOURCE="${BUILD_DIR}"
	autotools-utils_src_configure
}

gtest-config_install() {
	dobin "${BUILD_DIR}/scripts/gtest-config"
}
