EAPI=4

inherit autotools base gnome2-utils

MY_PN="evolution-indicator"
UURL="http://archive.ubuntu.com/ubuntu/pool/main/e/${MY_PN}"
UVER="0ubuntu8"
URELEASE="quantal"
GNOME2_LA_PUNT="1"

DESCRIPTION="Evolution mail client indicator used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_PN}_${PV}.orig.tar.gz
	${UURL}/${MY_PN}_${PV}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/vala:0.14[vapigen]
	dev-libs/libappindicator
	>=dev-libs/libdbusmenu-0.6.1[gtk]
	dev-libs/libindicate-qt
	mail-client/evolution
	unity-extra/indicator-messages"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	cd "${WORKDIR}"
	epatch "${MY_PN}_${PV}-${UVER}.diff"
	cd "${S}"
	for patch in $(ls -1 "debian/patches/") ; do
		PATCHES+=( "debian/patches/${patch}" )
	done
	base_src_prepare
	eautoreconf
}

pkg_preinst() {
                gnome2_schemas_savelist
}

pkg_postinst() {
                gnome2_schemas_update
}

pkg_postrm() {
                gnome2_schemas_update
}
