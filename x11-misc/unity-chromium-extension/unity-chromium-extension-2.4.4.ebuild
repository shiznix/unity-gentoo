EAPI=4

inherit autotools multilib

UURL="http://archive.ubuntu.com/ubuntu/pool/universe/u/${PN}"
UVER="0ubuntu1"
URELEASE="raring"
MY_P="${P/extension-/extension_}"

DESCRIPTION="Ubuntu Online Accounts browser extension"
HOMEPAGE="https://launchpad.net/online-accounts-browser-extension"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libunity-webapps
	>=www-client/chromium-99.23.0.1271.97"
# Webapp integration doesn't work for www-client/google-chrome #

S="${WORKDIR}/unity_webapps_chromium-${PV}"

src_prepare() {
	cp "${WORKDIR}/debian/unity-webapps.pem" .
	eautoreconf
}
