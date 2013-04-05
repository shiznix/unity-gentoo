EAPI=4

inherit base eutils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/f/${PN}"
URELEASE="quantal"

DESCRIPTION="uTouch Frame Library"
HOMEPAGE="https://launchpad.net/frame"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="!!unity-base/utouch-evemu
	!unity-base/utouch-frame
	>=sys-devel/gcc-4.6
	sys-libs/mtdev
	unity-base/evemu
	x11-base/xorg-server[dmx]
	>=x11-libs/libXi-1.5.99.1"

pkg_pretend() {
	if [[ ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ) ]]; then
		die "${P} requires an active >=gcc:4.6, please consult the output of 'gcc-config -l'"
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
