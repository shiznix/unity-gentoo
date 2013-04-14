EAPI=4

inherit ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/l/${PN}"
URELEASE="raring"
GNOME2_LA_PUNT="1"

DESCRIPTION="Configuration and a script to do a remote session using FreeRDP."
HOMEPAGE="https://launchpad.net/lightdm-remote-session-freerdp"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="net-misc/freerdp
	 >=gnome-extra/zenity-3.6.0
	 sys-apps/remote-login-service"
