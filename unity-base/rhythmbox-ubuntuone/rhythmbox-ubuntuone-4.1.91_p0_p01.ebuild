EAPI=4
PYTHON_DEPEND="2:2.7"
#SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit base distutils python ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/r/${PN}"
URELEASE="raring"

DESCRIPTION="Ubuntu One rhythmbox plugin for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/vala:0.14[vapigen]
	dev-libs/libubuntuone
	dev-libs/libzeitgeist
	dev-python/pygobject:2
	gnome-base/gnome-menus:3
	>=media-sound/rhythmbox-2.96[dbus,python]
	unity-base/ubuntuone-client
	unity-base/unity"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
	distutils_src_prepare
}
