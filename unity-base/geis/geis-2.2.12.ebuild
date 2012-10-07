EAPI=4

inherit base eutils python

UURL="http://archive.ubuntu.com/ubuntu/pool/main/g/${PN}"
UVER="0ubuntu2"
URELEASE="quantal"
MY_P="${P/-/_}"

DESCRIPTION="An implementation of the GEIS (Gesture Engine Interface and Support) interface"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!!unity-base/utouch-geis
	!!unity-base/utouch-grail
	dev-lang/python:2.7
	unity-base/grail"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -i 's/python >= 2.7/python-2.7 >= 2.7/g' configure
}
