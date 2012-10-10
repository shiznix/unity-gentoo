EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
UVER="0ubuntu2"
URELEASE="quantal"
MY_P="${P/application-/application_}"

DESCRIPTION="Application indicators used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/libappindicator-99.12.10.0
	>=dev-libs/libdbusmenu-99.12.10.2[gtk]
	dev-libs/libindicate-qt"

src_configure() {
	econf \
		--with-gtk=3 || die
}
