EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu1"
URELEASE="precise"
MY_P="${P/grail-/grail_}"

DESCRIPTION="An implementation of the GRAIL (Gesture Recognition And Instantiation Library) interface"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/mtdev
	unity-base/utouch-evemu
	unity-base/utouch-frame
	>=x11-libs/libXi-1.5.99.1"
