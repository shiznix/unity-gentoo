EAPI=4

inherit base autotools-utils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/z/${PN}"
UVER="1ubuntu2"
URELEASE="precise"
MY_P="${P/datahub-/datahub_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Provides passive plugins to insert events into zeitgeist"
HOMEPAGE="http://launchpad.net/zeitgeist-datahub"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
        ${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="download"

CDEPEND="dev-libs/libzeitgeist
	dev-libs/glib:2
	x11-libs/gtk+:2
	dev-lang/vala:0.12"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
PDEPEND="gnome-extra/zeitgeist"

src_configure() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare

	local myeconfargs=(
		$(use_enable download downloads-monitor)
		VALAC=$(type -P valac-0.12)
	)
	autotools-utils_src_configure
}
