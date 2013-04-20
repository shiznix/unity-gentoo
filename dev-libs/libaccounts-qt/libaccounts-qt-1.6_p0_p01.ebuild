EAPI=5

inherit qt4-r2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/liba/${PN}"
URELEASE="raring"
UVER_PREFIX="bzr13.02.27"

DESCRIPTION="QT library for Single Sign On framework for the Unity desktop"
HOMEPAGE="http://code.google.com/p/accounts-sso/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-2"
SLOT="0/1.4"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

RDEPEND="dev-libs/libaccounts-glib:=
	dev-qt/qtcore:4
	dev-qt/qtxmlpatterns:4
	doc? ( app-doc/doxygen )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	use doc || \
		for file in $(grep -r doc/doc.pri * | grep .pro | awk -F: '{print $1}'); do
			sed -e '/doc\/doc.pri/d' -i "${file}"
		done

	epatch "${FILESDIR}/0001-Do-not-initialize-QString-to-NULL.patch"
}
