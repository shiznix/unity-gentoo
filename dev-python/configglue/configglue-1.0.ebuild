EAPI=4
PYTHON_DEPEND="2:2.7 3:3.2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils python

DESCRIPTION="Library that glues together python's optparse.OptionParser and ConfigParser.ConfigParser"
HOMEPAGE="https://launchpad.net/configglue"
SRC_URI="http://pypi.python.org/packages/source/c/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

pkg_postinst() {
	python_disable_pyc
}
