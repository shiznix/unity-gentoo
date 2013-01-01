EAPI=4

inherit base eutils xorg-2

MY_PN="${PN/libXfixes/libxfixes}"
MY_PV="${PV/-r//}"
UURL="http://archive.ubuntu.com/ubuntu/pool/main/libx/${MY_PN}"
UVER="4ubuntu5"
URELEASE="quantal"

DESCRIPTION="Ubuntu patched version of X.Org Xfixes library needed for Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"

SRC_URI="${UURL}/${MY_PN}_${MY_PV}.orig.tar.gz
	${UURL}/${MY_PN}_${MY_PV}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	=x11-proto/fixesproto-5.0-r9999
	x11-proto/xproto
	x11-proto/xextproto"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${WORKDIR}/${MY_PN}_${MY_PV}-${UVER}.diff"
	for patch in $(cat "${WORKDIR}/${P}/${MY_PN}-${MY_PV}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/${P}/${MY_PN}-${MY_PV}/debian/patches/${patch}" )
	done
	base_src_prepare
}
