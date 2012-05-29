EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libi/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/-/_}"

DESCRIPTION="A set of symbols and convience functions that all indicators would like to use"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!dev-libs/libindicator
	=x11-libs/gtk+-99.3.4.2
	=x11-libs/libXfixes-5.0-r9999"
