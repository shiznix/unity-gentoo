EAPI=4

inherit base autotools

# Prefixing version with 99. so as not to break the overlay with upgrades in the main tree #
MY_PN="gtk3-engines-unico"
MY_PV="${PV/99./}"
MY_P="${MY_PN}_${MY_PV}"

S="${WORKDIR}/${MY_PN}-${MY_PV}+r139"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/g/${MY_PN}"
UVER="0ubuntu2"
URELEASE="quantal"

DESCRIPTION="The Unico GTK+ 3.x Theming Engine"
HOMEPAGE="https://launchpad.net/unico"
SRC_URI="${UURL}/${MY_P}+r139-${UVER}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
#KEYWORDS="amd64 ~ppc ~ppc64 x86"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-libs/glib-2.26
	>=x11-libs/cairo-1.10[glib]
	>=x11-libs/gtk+-99.3.3.14:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS NEWS" # ChangeLog and README are empty.
}

src_prepare() {
	eautoreconf
}

src_configure() {
	# $(use_enable debug) controls CPPFLAGS -D_DEBUG and -DNDEBUG but they are currently
	# unused in the code itself.
	econf \
		--disable-static \
		--disable-debug \
		--disable-maintainer-flags
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
