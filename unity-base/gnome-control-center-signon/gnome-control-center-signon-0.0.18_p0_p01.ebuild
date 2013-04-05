EAPI="5"
GNOME2_LA_PUNT="yes"

inherit autotools base eutils gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/g/${PN}"
URELEASE="quantal"

DESCRIPTION="Online account plugin for gnome-control-center used by the Unity desktop"
HOMEPAGE="https://launchpad.net/online-accounts-gnome-control-center"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="unity-base/signon-ui"

DEPEND="${RDEPEND}
	dev-libs/libaccounts-glib
	dev-libs/libsignon-glib
	gnome-base/gnome-control-center
	x11-proto/xproto
        x11-proto/xf86miscproto
        x11-proto/kbproto

        dev-libs/libxml2:2
        dev-libs/libxslt
        >=dev-util/intltool-0.40.1
        >=sys-devel/gettext-0.17
        virtual/pkgconfig
	x11-libs/gtk+:3"

S="${WORKDIR}/credentials-control-center-${PV}"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
	eautoreconf
}
