EAPI=4
SUPPORT_PYTHON_ABIS="1"

inherit distutils

UURL="http://archive.ubuntu.com/ubuntu/pool/universe/u/${PN}"
UVER="0ubuntu1"
URELEASE="precise"
MY_P="${P/singlet-/singlet_}"

DESCRIPTION="Python library for quickly building simple Unity lenses and scopes"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

DEPEND="dev-lang/python"
