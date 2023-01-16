# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

URELEASE="jammy"
inherit autotools eutils python-r1 ubuntu-versionator

UVER_PREFIX="+16.04.${PVR_MICRO}"

DESCRIPTION="An implementation of the GEIS (Gesture Engine Interface and Support) interface"
HOMEPAGE="https://launchpad.net/geis"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="unity-base/grail
	${PYTHON_DEPS}"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eapply "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure() {
	python_copy_sources
	configuration() {
		econf || die
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	compilation() {
		emake || die
	}
	python_foreach_impl run_in_build_dir compilation
}

src_install() {
	installation() {
		emake DESTDIR="${D}" install
	}
	python_foreach_impl run_in_build_dir installation

	# Remove unused libtool libarchive files #
	find "${ED}" -name '*.la' -delete || die
}
