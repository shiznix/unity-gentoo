EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit base distutils

UURL="http://archive.ubuntu.com/ubuntu/pool/universe/c/${PN}"
UVER="0ubuntu4"
URELEASE="precise"
MY_P="${P/python-/python_}"

DESCRIPTION="Compizconfig Python Bindings for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-libs/glib-2.6
	dev-python/cython
	=x11-libs/libcompizconfig-${PV}"
RDEPEND="${DEPEND}"
