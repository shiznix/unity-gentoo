EAPI=4

inherit autotools eutils gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER=""
URELEASE="raring"
GNOME2_LA_PUNT="1"

DESCRIPTION="Help files for the Unity desktop"
HOMEPAGE="https://launchpad.net/ubuntu-docs"
SRC_URI="${UURL}/${MY_P}.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=app-text/gnome-doc-utils-0.20.5
	app-text/yelp-tools
	dev-libs/libxml2
	gnome-extra/yelp"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_prepare() {
	eautoreconf
}
