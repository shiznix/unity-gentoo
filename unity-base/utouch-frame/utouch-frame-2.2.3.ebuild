EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu1"
URELEASE="precise"
MY_P="${P/frame-/frame_}"

DESCRIPTION="uTouch Frame Library"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-devel/gcc:4.6
	sys-libs/mtdev
	>=x11-libs/libXi-1.5.99.1"

src_prepare() {
	if [[ ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ) ]]; then
		die "${P} requires an active gcc:4.6, please consult the output of 'gcc-config -l'"
	fi
}
