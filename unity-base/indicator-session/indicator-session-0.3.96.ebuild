EAPI=4

inherit base eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
UVER="0ubuntu1"
URELEASE="precise"
MY_P="${P/session-/session_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Indicator showing power state used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-admin/packagekit[gtk,qt4]
	app-admin/packagekit-base[networkmanager,-nsplugin,policykit,udev]
	>=dev-libs/libappindicator-0.4.92
	>=dev-libs/libdbusmenu-0.6.1[gtk]
	dev-libs/libindicate-qt"

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
	../configure --prefix=/usr \
		--with-gtk=2 || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
	../configure --prefix=/usr \
		--with-gtk=3 || die
	popd
}

src_compile() {
	# Build GTK2 support #
	pushd build-gtk2
	emake || die
	popd

	# Build GTK3 support #
	pushd build-gtk3
	emake || die
	popd
}

src_install() {
        # Install GTK2 support #
        pushd build-gtk2
        emake DESTDIR="${D}" install || die
        popd

        # Install GTK3 support #
        pushd build-gtk3
        emake DESTDIR="${D}" install || die
        popd
}
