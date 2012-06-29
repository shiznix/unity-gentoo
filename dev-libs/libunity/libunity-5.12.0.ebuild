EAPI=4

inherit eutils autotools

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libu/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/-/_}"

DESCRIPTION="Essential libraries needed for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/dee
	>=dev-libs/libdbusmenu-0.6.1[gtk]
	dev-libs/libgee
	dev-lang/vala:0.14"
