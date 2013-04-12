EAPI=4
GNOME2_LA_PUNT="yes"

PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
URELEASE="quantal-updates"

DESCRIPTION="Remote video feeds fetched for the Unity desktop video lens"
HOMEPAGE="https://launchpad.net/unity-scope-video-remote"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="unity-base/unity
	unity-lenses/unity-lens-video"

src_prepare() {
	epatch "${WORKDIR}/${MY_P}-${UVER}.diff"
	python_convert_shebangs -r 2 .
	distutils_src_prepare
}
