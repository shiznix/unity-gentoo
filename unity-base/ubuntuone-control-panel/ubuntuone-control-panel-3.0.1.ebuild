EAPI=4

inherit distutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu1"
URELEASE="precise-updates"
MY_P="${P/panel-/panel_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Ubuntu One control panel for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/python
	dev-libs/dbus-glib
	gnome-base/nautilus"
RDEPEND="${DEPEND}
	dev-python/configglue
	dev-python/dbus-python
	dev-python/gnome-keyring-python
	dev-python/httplib2
	dev-python/notify-python
	>=dev-python/oauth-1.0
	>=dev-python/pygtk-2.10
	dev-python/dirspec
	dev-python/lazr-restfulclient
	dev-python/pyinotify
	dev-python/pyxdg
	dev-python/simplejson
	dev-python/twisted-names
	dev-python/twisted-web
	unity-base/ubuntu-sso-client
	unity-base/ubuntuone-storage-protocol
	x11-misc/lndir
	x11-misc/xdg-utils"

src_install() {
	# Delete some files that are only useful on Ubuntu
	rm -rf "${D}"etc/apport "${D}"usr/share/apport

	insinto /usr/share/applications/
	doins "${FILESDIR}/${PN}.desktop"
	distutils_src_install
}
