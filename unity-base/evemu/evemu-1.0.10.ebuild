EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/e/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/-/_}"

DESCRIPTION="Event Emulation for the uTouch Stack"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="!!unity-base/utouch-evemu"
