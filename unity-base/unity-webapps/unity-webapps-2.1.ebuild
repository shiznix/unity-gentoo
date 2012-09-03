EAPI=4

inherit eutils autotools

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libu/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/-/_}"

DESCRIPTION="Essential libraries needed for the Unity desktop"
HOMEPAGE="https://launchpad.net/libunity-webapps"
SRC_URI="https://launchpad.net/libunity-webapps/trunk/${PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Repair library naming #
	sed -e 's:lunity_webapps:lunity-webapps:g' \
		-i src/libunity-webapps/libunity_webapps-0.2.pc.in \
			src/libunity-webapps-repository/libunity-webapps-repository.pc.in
}
