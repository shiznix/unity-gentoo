EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit base distutils

MY_PN="compizconfig-settings-manager"
MY_P="${MY_PN}_${PV}"
UURL="http://archive.ubuntu.com/ubuntu/pool/universe/c/${PN}"
UVER="0ubuntu3"
URELEASE="precise"

DESCRIPTION="Compizconfig Settings Manager for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="!x11-apps/ccsm
	=unity-base/compizconfig-python-0.9.5.94
	=unity-base/compizconfig-backend-gconf-0.9.5.92
	>=dev-python/pygtk-2.10"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${WORKDIR}/${MY_P}-${UVER}.diff"
	for patch in ${MY_PN}-${PV}/debian/patches/*.patch; do
		PATCHES+=( "${patch}" )
	done
	base_src_prepare
}

src_install() {
	distutils_src_install --prefix="/usr"
}
