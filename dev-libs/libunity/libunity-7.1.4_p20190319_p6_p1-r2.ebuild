# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

MY_PV="${PV}"
URELEASE="jammy"
inherit autotools eutils python-r1 ubuntu-versionator vala

UVER_PREFIX="+19.04.${PVR_MICRO}"
UVER="-${PVR_PL_MAJOR}build${PVR_PL_MINOR}"

DESCRIPTION="Library for instrumenting and integrating with all aspects of the Unity shell"
HOMEPAGE="https://launchpad.net/libunity"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0/9.0.2"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/vala:0.52
	>=dev-libs/dee-1.2.5:=
	dev-libs/libdbusmenu:=
	x11-libs/gtk+:3
	${PYTHON_DEPS}"

S="${WORKDIR}/${PN}-${MY_PV}${UVER_PREFIX}"

src_unpack() {
	unpack ${A}
	mkdir ${PN}-${PV}${UVER_PREFIX}
	mv * ${PN}-${PV}${UVER_PREFIX} &> /dev/null
}

src_prepare() {
	eapply "${S}/${MY_P}${UVER_PREFIX}${UVER}.diff"
	ubuntu-versionator_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
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
