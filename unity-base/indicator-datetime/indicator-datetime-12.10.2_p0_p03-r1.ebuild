EAPI=4
GNOME2_LA_PUNT="yes"

inherit eutils flag-o-matic gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
URELEASE="quantal"

DESCRIPTION="Indicator for application menus used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-datetime"
SRC_URI="${UURL}/${PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="unity-base/unity-language-pack"
DEPEND="dev-libs/libappindicator
	dev-libs/libdbusmenu[gtk]
	dev-libs/libindicate-qt
	dev-libs/libtimezonemap
	gnome-base/gnome-control-center
	>=gnome-extra/evolution-data-server-3.6
	unity-base/ido"

src_prepare() {
	append-cflags -Wno-error
}

src_configure() {
	econf --with-ccpanel
}

src_install() {
	gnome2_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf ${ED}usr/share/locale
}

