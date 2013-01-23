EAPI=4
PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils distutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/protocol-/protocol_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Ubuntu One file storage and sharing service for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/protobuf[python]"
RDEPEND="${DEPEND}
	dev-python/dirspec
	>=dev-python/oauth-1.0
	dev-python/pyopenssl
	>=dev-python/twisted-12.2.0
	dev-python/pyxdg"
