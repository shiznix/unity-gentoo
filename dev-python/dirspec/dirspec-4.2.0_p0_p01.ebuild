EAPI=4
GNOME2_LA_PUNT="yes"

PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/d/${PN}"
URELEASE="raring"

DESCRIPTION="Python User Folders Specification Library"
HOMEPAGE="https://launchpad.net/dirspec"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/python"
