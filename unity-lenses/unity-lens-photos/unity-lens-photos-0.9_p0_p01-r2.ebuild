EAPI=4
PYTHON_DEPEND="3:3.2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
URELEASE="raring"
UVER_PREFIX="daily12.12.05"

DESCRIPTION="Photo lens for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-photos"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/dee
        dev-libs/libgee
        net-libs/liboauth
        net-libs/libsoup
        dev-libs/libunity
	dev-python/httplib2
	dev-python/oauthlib
	media-gfx/shotwell
	net-libs/account-plugins
	unity-base/unity
	unity-base/unity-language-pack"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	python_convert_shebangs -r 3 .
	distutils_src_prepare
}

src_install() {
	distutils_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf ${ED}usr/share/locale
}
