EAPI=4

URELEASE="precise"
MY_PN="unity-stock-ticker-lens"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Stocks quote ticker lens used by the Unity desktop"
HOMEPAGE="https://code.launchpad.net/~scopes-packagers/+archive/ppa/+packages"
SRC_URI="https://code.launchpad.net/~scopes-packagers/+archive/ppa/+files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="asx"

DEPEND="dev-python/feedparser
	dev-python/unity-singlet
	unity-base/unity"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	# Support quotes from the ASX #
	use asx && \
		sed -e 's:\?s=\%s\&:\?s=\%s.ax\&:g' \
			-i "yahoo_stock.py"
}

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
