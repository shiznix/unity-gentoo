EAPI=4

inherit distutils eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu1"
URELEASE="precise-updates"
MY_P="${P/client-/client_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Ubuntu Single Sign-On client for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/python
	dev-python/configglue
	dev-python/dbus-python
	dev-python/gnome-keyring-python
	dev-python/httplib2
	dev-python/imaging
	dev-python/notify-python
	>=dev-python/oauth-1.0
	dev-python/PyQt4
	>=dev-python/pygtk-2.10
	dev-python/pyinotify
	>=dev-python/python-distutils-extra-2.29
	dev-python/pyxdg
	dev-python/simplejson
	dev-python/twisted-names
	dev-python/twisted-web"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		epatch -p1 "${WORKDIR}/debian/patches/${patch}" || die;
	done
	distutils_src_prepare
}
