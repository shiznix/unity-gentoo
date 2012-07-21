EAPI=4

inherit distutils

UURL="http://archive.ubuntu.com/ubuntu/pool/universe/p/${PN}"
UVER="1"
URELEASE="precise"
MY_P="${P/-/_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Python wrapper around different weather APIs"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/vala:0.14[vapigen]
	>=dev-libs/libappindicator-0.4.92
	>=dev-libs/libdbusmenu-0.6.1[gtk]
	dev-libs/libindicate-qt"

src_install() {
	# Delete some files that are only useful on Ubuntu
	rm -rf "${D}"etc/apport "${D}"usr/share/apport

	distutils_src_install
}
