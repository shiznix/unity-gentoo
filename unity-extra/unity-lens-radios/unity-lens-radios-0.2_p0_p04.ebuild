EAPI=4
PYTHON_DEPEND="3:3.2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.*"

inherit distutils ubuntu-versionator

URELEASE="raring"

DESCRIPTION="Online radio lens used by the Unity desktop"
HOMEPAGE="https://launchpad.net/ubuntu/${URELEASE}/+source/${PN}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/python:3.2
	>=dev-python/python-distutils-extra-2.37
	unity-base/unity"
