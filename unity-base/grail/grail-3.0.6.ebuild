EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/g/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/-/_}"

DESCRIPTION="An implementation of the GRAIL (Gesture Recognition And Instantiation Library) interface"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="!unity-base/utouch-grail
	sys-devel/gcc:4.6
	sys-libs/mtdev
	unity-base/evemu
	unity-base/frame
	>=x11-libs/libXi-1.5.99.1"

src_prepare() {
	if [[ ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ) ]]; then
		die "${P} requires an active gcc:4.6, please consult the output of 'gcc-config -l'"
	fi
}
