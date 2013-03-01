EAPI=5

XORG_MULTILIB=yes
inherit base eutils xorg-2 ubuntu-versionator

MY_PN="libxfixes"
MY_P="${MY_PN}_${PV}"
UURL="http://archive.ubuntu.com/ubuntu/pool/main/libx/${MY_PN}"
URELEASE="raring"

DESCRIPTION="Ubuntu patched version of X.Org Xfixes library needed for Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"

SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"


RDEPEND="x11-libs/libX11[${MULTILIB_USEDEP}]
	>=x11-proto/fixesproto-5[${MULTILIB_USEDEP}]
	x11-proto/xproto[${MULTILIB_USEDEP}]
	x11-proto/xextproto[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${WORKDIR}/${MY_P}-${UVER}.diff"
	for patch in $(cat "${WORKDIR}/${PN}-${PV}/${MY_PN}-${PV}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/${PN}-${PV}/${MY_PN}-${PV}/debian/patches/${patch}" )
	done
	base_src_prepare
}
