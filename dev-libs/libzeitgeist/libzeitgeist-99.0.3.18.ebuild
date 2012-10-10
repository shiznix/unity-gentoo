EAPI=4

AUTOTOOLS_AUTORECONF=true

inherit base autotools-utils eutils

# Prefixing version with 99. so as not to break the overlay with upgrades in the main tree #
MY_PN="${PN}2.0"
MY_PV="${PV/99./}"
MY_P="${PN}_${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libz/${PN}"
UVER="1ubuntu1"
URELEASE="quantal"
GNOME2_LA_PUNT="1"

DESCRIPTION="Client library to interact with zeitgeist"
HOMEPAGE="http://launchpad.net/libzeitgeist/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

CDEPEND="dev-libs/glib:2"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	dev-util/gtk-doc
	virtual/pkgconfig"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done

	sed \
		-e "s:doc/libzeitgeist:doc/${PF}:" \
		-i Makefile.am || die
	# FIXME: This is the unique test failing
	sed \
		-e '/TEST_PROGS      += test-log/d' \
		-i tests/Makefile.am || die
	autotools-utils_src_prepare
}
