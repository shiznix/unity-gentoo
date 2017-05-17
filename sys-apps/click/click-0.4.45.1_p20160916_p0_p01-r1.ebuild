# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python3_4 )

URELEASE="yakkety"
inherit autotools distutils-r1 ubuntu-versionator vala

UURL="mirror://unity/pool/main/c/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Ubuntu mobile platform package management framework"
HOMEPAGE="https://launchpad.net/click"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls systemd"
RESTRICT="mirror"

RDEPEND="dev-lang/perl
	dev-util/schroot"
DEPEND="${RDEPEND}
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee:0.8
	nls? ( virtual/libintl )
	$(vala_depend)"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	distutils-r1_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}

src_configure() {
	export PYTHON_INSTALL_FLAGS="--force --no-compile --root=${ED}"
	econf \
		--prefix=/usr \
		--disable-packagekit \
		$(use_enable nls) \
		$(use_enable systemd)
}

src_install() {
	default
	prune_libtool_files --modules
}
