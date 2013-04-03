EAPI=4
PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/d/${PN}"
URELEASE="quantal"
GNOME2_LA_PUNT="1"

DESCRIPTION="Python User Folders Specification Library"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/python"
