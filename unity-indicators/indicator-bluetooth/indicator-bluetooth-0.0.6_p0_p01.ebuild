EAPI=5
GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.20"
VALA_USE_DEPEND="vapigen"

inherit autotools base eutils gnome2 ubuntu-versionator vala

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.02.19"

DESCRIPTION="System bluetooth indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-bluetooth"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	unity-indicators/ido:="
DEPEND="${RDEPEND}
	dev-libs/glib
	dev-libs/libappindicator
	dev-libs/libindicator
	gnome-base/dconf
	net-wireless/gnome-bluetooth
	x11-libs/gtk+:3"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	vala_src_prepare
        export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}

src_install() {
	gnome2_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf ${ED}usr/share/locale
}
