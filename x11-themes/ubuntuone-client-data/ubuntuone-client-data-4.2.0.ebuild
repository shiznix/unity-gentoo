EAPI=4
SUPPORT_PYTHON_ABIS="1"

inherit distutils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER=""
URELEASE="quantal"

DESCRIPTION="Data files used by the Ubuntu One suite"
HOMEPAGE="https://launchpad.net/ubuntuone-client-data"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
RESTRICT="mirror"

DEPEND=">=dev-python/python-distutils-extra-2.37"

src_install() {
	distutils_src_install

	# Removed apport stuff #
	rm -rf "${ED}etc" "${ED}usr/share/apport"
}
