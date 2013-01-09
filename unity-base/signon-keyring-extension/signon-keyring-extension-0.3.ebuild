EAPI=4

inherit base qt4-r2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/s/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/extension-/extension_}"

DESCRIPTION="GNOME keyring extension for signond used by the Unity desktop"
HOMEPAGE="http://code.google.com/p/accounts-sso/"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="unity-base/signon
	x11-libs/qt-core"
DEPEND="${RDEPEND}"

S="${WORKDIR}/keyring-${PV}"
