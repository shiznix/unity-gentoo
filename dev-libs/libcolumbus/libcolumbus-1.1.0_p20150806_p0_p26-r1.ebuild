# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

URELEASE="jammy"
inherit cmake eutils python-r1 ubuntu-versionator

UVER_PREFIX="+15.10.${PVR_MICRO}"

DESCRIPTION="Error tolerant matching engine used by the Unity desktop"
HOMEPAGE="https://launchpad.net/libcolumbus"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"
REQUIRED_USE="test? ( debug )"
RESTRICT="mirror"

DEPEND="dev-cpp/sparsehash
	dev-libs/boost:=[python,${PYTHON_USEDEP}]
	>=dev-libs/icu-52:=
	${PYTHON_DEPS}"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eapply "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"
	rm -r "${S}"/debian/patches     # patches already applied
	ubuntu-versionator_src_prepare

	# Unset BUILD_DIR so python_copy_sources uses S source directory #
	unset BUILD_DIR
	python_copy_sources
	preparation() {
		python_fix_shebang .
		cp -rfv python/pch/colpython_pch.hh "${BUILD_DIR}/python/colpython_pch.hh"
		cmake_src_prepare
	}
	python_foreach_impl run_in_build_dir preparation
}

src_configure() {
	configuration() {
		mycmakeargs+=(-DPYTHONDIR="$(python_get_sitedir)")
		cmake_src_configure
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	compilation() {
		cmake_src_compile
	}
	python_foreach_impl run_in_build_dir compilation
}

src_test() {
	testing() {
		cmake_src_test
	}
	python_foreach_impl run_in_build_dir testing
}

src_install() {
	installation() {
		cmake_src_install
	}
	python_foreach_impl run_in_build_dir installation

	local DOCS=( 'coding style.txt' COPYING hacking.txt readme.txt )
	einstalldocs
}
