EAPI=4
PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu2"
URELEASE="quantal"
MY_P="${P/video-/video_}"

DESCRIPTION="Application lens for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-libs/dee-99.1.0.14
	dev-libs/libunity"
DEPEND="${RDEPEND}
	unity-base/unity"

src_prepare() {
	epatch "${WORKDIR}/${MY_P}-${UVER}.diff"
	python_convert_shebangs -r 2 .
	distutils_src_prepare
}
