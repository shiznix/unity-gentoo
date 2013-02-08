EAPI=4
PYTHON_DEPEND="3:3.2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
URELEASE="quantal-updates"

DESCRIPTION="Photo lens for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=dev-libs/dee-1.0.14
	dev-libs/libunity"
DEPEND="${RDEPEND}
	dev-libs/libaccounts-glib
	dev-libs/libsignon-glib
	dev-python/httplib2
	>=dev-python/oauthlib-0.3.4
	media-gfx/shotwell
	unity-base/unity"

src_prepare() {
	epatch "${WORKDIR}/${MY_P}-${UVER}.diff"
	python_convert_shebangs -r 3 .
	distutils_src_prepare
}
