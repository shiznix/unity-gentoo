EAPI=4

inherit base eutils xorg-2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-fixes"
UVER="2ubuntu1"
URELEASE="precise"
MY_PV="${PV/-r//}"

DESCRIPTION="Ubuntu patched version of X.Org Fixes protocol headers needed for Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"

SRC_URI="${UURL}/x11proto-fixes_${MY_PV}.orig.tar.gz
	${UURL}/x11proto-fixes_${MY_PV}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-proto/xextproto-7.0.99.1"
DEPEND="${RDEPEND}"

src_prepare() {
        epatch "${WORKDIR}/x11proto-fixes_${MY_PV}-${UVER}.diff"
        for patch in $(cat "${WORKDIR}/${P}/x11proto-fixes-${MY_PV}/debian/patches/series" | grep -v '#'); do
                PATCHES+=( "${WORKDIR}/${P}/x11proto-fixes-${MY_PV}/debian/patches/${patch}" )
        done
        base_src_prepare
}
