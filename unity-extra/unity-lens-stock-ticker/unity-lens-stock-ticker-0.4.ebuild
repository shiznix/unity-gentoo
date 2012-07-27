EAPI=4

URELEASE="precise"
MY_PN="unity-stock-ticker-lens"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Stocks quote ticker indicator used by the Unity desktop"
HOMEPAGE="https://code.launchpad.net/~scopes-packagers/+archive/ppa/+packages"
SRC_URI="https://code.launchpad.net/~scopes-packagers/+archive/ppa/+files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/libappindicator-99.0.4.92
	>=dev-libs/libdbusmenu-0.6.1[gtk]
	dev-libs/libindicate-qt
	dev-python/feedparser"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	insinto /usr/share/dbus-1/services
	doins *.service

	insinto /usr/share/unity/lenses/stockquote
	doins stockquote.lens
	doins yahoostock.scope

	exeinto /opt/extras.ubuntu.com/${MY_PN}
	doexe stockquote-lens \
		yahoostock-scope \
		yahoo_stock.py

	insinto /opt/extras.ubuntu.com/${MY_PN}
	doins *.png
}
