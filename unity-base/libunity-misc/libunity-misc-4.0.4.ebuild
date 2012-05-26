EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libu/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/misc-/misc_}"

DESCRIPTION="Miscellaneous modules for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="=x11-libs/libXfixes-5.0-r9999"
