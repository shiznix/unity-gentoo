EAPI=5

inherit autotools eutils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libu/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.02.26"

DESCRIPTION="Miscellaneous modules for the Unity desktop"
HOMEPAGE="https://launchpad.net/libunity-misc"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/4.1.0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

DEPEND="x11-libs/gtk+:3
	x11-libs/libXfixes"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
        # Make docs optional #
	! use doc && \
		sed -e 's:unity-misc doc:unity-misc:' \
			-i Makefile.am
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
