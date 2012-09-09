EAPI=4
PYTHON_DEPEND="3:3.2"
RESTRICT_PYTHON_ABIS="2.*"

inherit distutils python

URELEASE="precise"
MY_P="${P/cooking-/cooking_}"

DESCRIPTION="Cooking recipe search used by the Unity desktop"
HOMEPAGE="https://code.launchpad.net/~scopes-packagers/+archive/ppa/+packages"
SRC_URI="https://code.launchpad.net/~scopes-packagers/+archive/ppa/+files/${MY_P}-0~64~${URELEASE}1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libunity
	dev-python/lxml
	unity-base/unity"

S="${WORKDIR}/recipe-{debupstream}-0~{revno}"
