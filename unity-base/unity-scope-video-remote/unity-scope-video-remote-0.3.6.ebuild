EAPI=4
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/remote-/remote_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Remote video feeds fetched for the Unity desktop video lens"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="unity-base/unity
	unity-base/unity-lens-video"

src_prepare() {
	epatch "${WORKDIR}/${MY_P}-${UVER}.diff"
	distutils_src_prepare
}
