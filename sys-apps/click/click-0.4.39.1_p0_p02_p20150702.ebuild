# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{3_4,3_5} )
VALA_MIN_API_VERSION="0.28"
VALA_MAX_API_VERSION="0.28"

URELEASE="wily"
inherit autotools distutils-r1 ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/c/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Ubuntu mobile platform package management framework"
HOMEPAGE="https://launchpad.net/click"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls systemd"
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee:0.8
	nls? ( virtual/libintl )
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	mv "${WORKDIR}/debian" "${S}/"      # aclocal executes 'get-version' from source tree requiring existence of debian/Changelog
	ubuntu-versionator_src_prepare
	distutils-r1_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}

src_configure() {
	distutils-r1_src_configure
	econf \
		--disable-packagekit \
		$(use_enable nls) \
		$(use_enable systemd)
}

src_compile() {
	rm -rfv tests/
	distutils-r1_src_compile
	pushd lib/
		emake
	popd
}

src_install() {
	distutils-r1_src_install
	pushd lib/
		emake DESTDIR="${ED}" install
	popd
	prune_libtool_files --modules
}
