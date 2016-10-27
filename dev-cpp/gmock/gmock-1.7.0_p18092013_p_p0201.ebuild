# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

URELEASE="yakkety"
inherit libtool python-single-r1 ubuntu-versionator

MY_PN="google-mock"
MY_PV="${PV}"
UURL="mirror://unity/pool/universe/g/${MY_PN}"
UVER="-${PVR_MICRO}"
UVER_SUFFIX="-${PVR_PL_MINOR}"

DESCRIPTION="Google's C++ mocking framework patched for the Unity desktop"
HOMEPAGE="http://code.google.com/p/googlemock/"
SRC_URI="${UURL}/${MY_PN}_${PV}${UVER}.orig.tar.bz2
	${UURL}/${MY_PN}_${PV}${UVER}${UVER_SUFFIX}.debian.tar.xz"

LICENSE="BSD"
SLOT="0"
#KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="=dev-cpp/gtest-${PV}*"
DEPEND="${RDEPEND}
	app-arch/unzip
	${PYTHON_DEPS}"
RESTRICT="mirror"

S="${WORKDIR}/${MY_PN}-${MY_PV}${UVER}"

src_unpack() {
	default
	# make sure we always use the system one
	rm -r "${S}"/gtest/{Makefile,configure}* || die
}

src_prepare() {
	ubuntu-versionator_src_prepare
	sed -i -r \
		-e '/^install-(data|exec)-local:/s|^.*$|&\ndisabled-&|' \
			Makefile.in
	elibtoolize
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	dobin scripts/gmock-config
	use static-libs || find "${D}" -name '*.la' -delete

	insinto /usr/src/gmock/src
	doins -r src/*.cc

	insinto /usr/src/gmock
	doins -r gtest CMakeLists.txt
}
