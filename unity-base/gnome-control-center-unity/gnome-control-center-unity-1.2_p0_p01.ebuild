EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools base eutils gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/g/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.04.09"

DESCRIPTION="GNOME control center module to change the settings of the Unity desktop"
HOMEPAGE="https://launchpad.net/gnome-control-center-unity"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
        ${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="+socialweb"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="socialweb? ( net-libs/libsocialweb )
	gnome-base/gnome-control-center
	gnome-base/gsettings-desktop-schemas
	x11-proto/xproto
        x11-proto/xf86miscproto
        x11-proto/kbproto

        dev-libs/libxml2:2
        dev-libs/libxslt
        >=dev-util/intltool-0.40.1
        >=sys-devel/gettext-0.17
        virtual/pkgconfig"

PATCHES=( "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff" )
S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	base_src_prepare
	eautoreconf
}
