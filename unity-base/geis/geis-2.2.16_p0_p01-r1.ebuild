# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{3_2,3_3} )

inherit autotools eutils python-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/g/${PN}"
URELEASE="saucy"
UVER_PREFIX="+13.10.20130919.4"

DESCRIPTION="An implementation of the GEIS (Gesture Engine Interface and Support) interface"
HOMEPAGE="https://launchpad.net/geis"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="unity-base/grail"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	python_export_best
	local python_best_ver=${EPYTHON/python}
	sed -e "s:python3:python-${python_best_ver}:" \
		-i configure.ac || die
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
