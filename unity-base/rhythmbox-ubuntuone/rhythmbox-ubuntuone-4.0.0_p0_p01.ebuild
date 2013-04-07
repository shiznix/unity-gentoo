EAPI=4
PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/r/${PN}"
URELEASE="quantal"

DESCRIPTION="Ubuntu One rhythmbox plugin for the Unity desktop"
HOMEPAGE="https://launchpad.net/rhythmbox-ubuntuone"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/vala:0.14[vapigen]
	dev-libs/libubuntuone
	dev-libs/libzeitgeist
	dev-python/pygobject:2
	gnome-base/gnome-menus:3
	>=media-sound/rhythmbox-2.98[dbus,python,zeitgeist]
	unity-base/ubuntuone-client
	unity-base/unity
	x11-themes/ubuntuone-client-data"
