# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="3:3.2"
SUPPORT_PYTHON_ABIS="1"

inherit autotools eutils python ubuntu-versionator

UURL="mirror://ubuntu/pool/main/g/${PN}"
URELEASE="saucy"
UVER_PREFIX="daily13.06.05"

DESCRIPTION="An implementation of the GEIS (Gesture Engine Interface and Support) interface"
HOMEPAGE="https://launchpad.net/geis"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="unity-base/grail"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	sed -e "s:python3:python-3.2:" \
		-i configure.ac || die
	eautoreconf
	export EPYTHON="$(PYTHON -3)"
	python_convert_shebangs -r 3 .
	python_src_prepare
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
