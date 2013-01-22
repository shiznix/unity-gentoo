EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools base eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/g/${PN}"
UVER="0ubuntu1"
URELEASE="raring"
MY_P="${P/unity-/unity_}"

DESCRIPTION="GNOME control center module to change the settings of the Unity desktop"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
        ${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+socialweb"
KEYWORDS="~amd64 ~x86"

DEPEND="socialweb? ( net-libs/libsocialweb )
	>=gnome-base/gnome-control-center-99.3.6.3
	>=gnome-base/gsettings-desktop-schemas-99.3.6.0
	x11-proto/xproto
        x11-proto/xf86miscproto
        x11-proto/kbproto

        dev-libs/libxml2:2
        dev-libs/libxslt
        >=dev-util/intltool-0.40.1
        >=sys-devel/gettext-0.17
        virtual/pkgconfig"

PATCHES=( "${WORKDIR}/${MY_P}-${UVER}.diff" )

src_prepare() {
	base_src_prepare
	eautoreconf
}
