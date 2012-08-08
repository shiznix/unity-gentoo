EAPI=4
inherit base cmake-utils eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libi/${PN}"
UVER="1ubuntu3"
URELEASE="precise"
MY_P="${P/qt-/qt_}"

DESCRIPTION="Qt wrapper for libindicate library"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/libindicate-99.0.6.92
	>=x11-libs/qt-core-99.4.8.2:4
	>=x11-libs/qt-test-99.4.8.2:4"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
}
