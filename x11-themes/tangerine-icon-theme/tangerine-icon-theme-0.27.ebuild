EAPI=4
inherit gnome2-utils ubuntu-versionator

URELEASE="raring"
UVER=""

DESCRIPTION="A derivative of the standard Tango theme, using a more orange approach"
HOMEPAGE="http://packages.ubuntu.com/gutsy/x11/tangerine-icon-theme"
SRC_URI="mirror://ubuntu/pool/universe/t/${PN}/${PN}_${PV}.tar.gz"

LICENSE="CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="binchecks strip mirror"

DEPEND="dev-util/intltool
	sys-devel/gettext
	x11-misc/icon-naming-utils"

src_unpack() {
	unpack ${PN}_${PV}.tar.gz
}

src_prepare() {
	sed -e 's:lib/icon-naming-utils/icon:libexec/icon:' \
		-i Makefile || die
}

src_compile() {
	emake index.theme
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
