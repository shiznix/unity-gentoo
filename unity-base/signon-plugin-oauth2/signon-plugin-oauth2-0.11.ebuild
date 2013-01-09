EAPI=4

inherit base qt4-r2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/s/${PN}"
UVER="0ubuntu3"
URELEASE="quantal"
MY_P="${P/oauth2-/oauth2_}"

DESCRIPTION="Single Signon oauth2 plugin used by the Unity desktop"
HOMEPAGE="http://code.google.com/p/accounts-sso/"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/qjson
	unity-base/signon-ui
	x11-libs/qt-core"
DEPEND="${RDEPEND}"

S="${WORKDIR}/signon-oauth2-${PV}"

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
}
