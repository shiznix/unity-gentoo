EAPI=4

inherit base eutils python

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu3"
URELEASE="precise-updates"
MY_P="${P/geis-/geis_}"

DESCRIPTION="An implementation of the GEIS (Gesture Engine Interface and Support) interface"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!!unity-base/geis
	dev-lang/python:2.7
	unity-base/utouch-grail"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare

	sed -i 's/python >= 2.7/python-2.7 >= 2.7/g' configure
}
