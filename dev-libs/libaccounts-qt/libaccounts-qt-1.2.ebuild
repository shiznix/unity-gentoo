EAPI=4

inherit qt4-r2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/liba/${PN}"
UVER="0ubuntu2"
URELEASE="quantal"
MY_P="${P/qt-/qt_}"

DESCRIPTION="QT library for Single Sign On framework for the Unity desktop"
HOMEPAGE="http://code.google.com/p/accounts-sso/"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-libs/libaccounts-glib
	x11-libs/qt-core
	x11-libs/qt-xmlpatterns
	doc? ( app-doc/doxygen )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/accounts-qt-${PV}"

src_prepare() {
	use doc || \
		for file in $(grep -r doc/doc.pri * | grep .pro | awk -F: '{print $1}'); do
			sed -e '/doc\/doc.pri/d' -i "${file}"
		done
}
