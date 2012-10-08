EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/f/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/-/_}"

DESCRIPTION="uTouch Frame Library"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!!unity-base/utouch-evemu
	!unity-base/utouch-frame
	sys-devel/gcc:4.6
	sys-libs/mtdev
	unity-base/evemu
	=x11-base/xorg-server-1.13.0-r9999[dmx]
	>=x11-libs/libXi-1.5.99.1"

pkg_pretend() {
	if [[ ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ) ]]; then
		die "${P} requires an active gcc:4.6, please consult the output of 'gcc-config -l'"
	fi
}
