EAPI=4
PYTHON_DEPEND="2:2.7"

inherit autotools eutils python ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/universe/e/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.02.20"

DESCRIPTION="Event Emulation for the uTouch Stack"
HOMEPAGE="https://launchpad.net/evemu"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
