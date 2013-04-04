EAPI=4

inherit base qt4-r2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/s/${PN}"
URELEASE="quantal"

DESCRIPTION="GNOME keyring extension for signond used by the Unity desktop"
HOMEPAGE="https://launchpad.net/signon-keyring-extension"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

RDEPEND="gnome-base/libgnome-keyring
	dev-qt/qtcore:4
	unity-base/signon"
DEPEND="${RDEPEND}"

S="${WORKDIR}/keyring-${PV}"
