EAPI=4

inherit distutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/d/${PN}"
UVER="0ubuntu1"
URELEASE="precise"
MY_P="${P/-/_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Ubuntu One control panel for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/python"
