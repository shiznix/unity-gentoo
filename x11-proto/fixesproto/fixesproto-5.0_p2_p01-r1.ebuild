EAPI=5

XORG_MULTILIB=yes

inherit base eutils xorg-2 ubuntu-versionator

MY_PN="x11proto-fixes"
MY_P="${MY_PN}_${PV}"
UURL="http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-fixes"
URELEASE="quantal"

DESCRIPTION="Ubuntu patched version of X.Org Fixes protocol headers needed for Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"

SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=x11-proto/xextproto-7.0.99.1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	PV="${PV%%_p*}"
	epatch "${WORKDIR}/${MY_P}-${UVER}.diff"
	for patch in $(cat "${WORKDIR}/${PN}-${PV}/${MY_PN}-${PV}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/${PN}-${PV}/${MY_PN}-${PV}/debian/patches/${patch}" )
	done
	xorg-2_src_configure
}
