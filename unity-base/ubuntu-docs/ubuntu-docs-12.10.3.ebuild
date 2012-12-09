EAPI=4

inherit autotools eutils gnome2

UURL="https://launchpad.net/ubuntu/+archive/primary/+files/"
UVER=""
URELEASE="quantal"
MY_P="${P/docs-/docs_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Help files for the Unity desktop"
HOMEPAGE="https://launchpad.net/ubuntu-docs/quantal"
SRC_URI="${UURL}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=app-text/gnome-doc-utils-0.20.5
	dev-libs/libxml2
	gnome-extra/yelp"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_prepare() {
	eautoreconf
}
