EAPI=5
PYTHON_DEPEND="2:2.7 3:3.2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils ubuntu-versionator

DESCRIPTION="A library to manipulate gettext files (po and mo files)"
HOMEPAGE="http://bitbucket.org/izi/polib/"
SRC_URI="http://bitbucket.org/izi/polib/downloads/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
