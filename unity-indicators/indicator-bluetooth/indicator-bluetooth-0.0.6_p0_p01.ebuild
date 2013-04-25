EAPI=5
GNOME2_LA_PUNT="yes"

inherit autotools base eutils gnome2 ubuntu-versionator

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

RDEPEND="dev-libs/libdbusmenu:=[gtk]"
DEPEND="${RDEPEND}
	dev-lang/vala:0.16[vapigen]
	dev-libs/glib
	dev-libs/libappindicator
	dev-libs/libindicator
	gnome-base/dconf
	net-wireless/gnome-bluetooth
	unity-indicators/ido
	x11-libs/gtk+:3"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
        export VALAC=$(type -P valac-0.16)
        export VALA_API_GEN=$(type -p vapigen-0.16)
	eautoreconf
}

src_install() {
	gnome2_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf ${ED}usr/share/locale
}
