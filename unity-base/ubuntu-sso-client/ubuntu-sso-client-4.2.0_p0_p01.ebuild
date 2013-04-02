EAPI=4
PYTHON_DEPEND="2:2.7"
#SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils python ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
URELEASE="raring"

DESCRIPTION="Ubuntu Single Sign-On client for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/python
	>=dev-libs/glib-2.32.3
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
	>=dev-python/python-distutils-extra-2.37
	dev-python/pyxdg
	dev-python/simplejson
	>=dev-python/twisted-names-12.2.0
	>=dev-python/twisted-web-12.2.0"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r 2 .
}

pkg_postinst() {
	python_disable_pyc
}
