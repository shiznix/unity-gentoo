EAPI=4

inherit autotools eutils multilib ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/universe/u/${PN}"
URELEASE="raring"

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
	www-client/chromium"
# Webapp integration doesn't work for www-client/google-chrome #

S="${WORKDIR}/unity_webapps_chromium-${PV}"

src_prepare() {
	cp "${WORKDIR}/debian/unity-webapps.pem" .
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
