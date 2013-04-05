EAPI=4
PYTHON_DEPEND="2:2.7"

inherit base eutils python ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/e/${PN}"
URELEASE="quantal"

DESCRIPTION="Event Emulation for the uTouch Stack"
HOMEPAGE="https://launchpad.net/evemu"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="!!unity-base/utouch-evemu"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
