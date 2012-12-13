EAPI=4

inherit eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/i/${PN}"
UVER="0ubuntu1"
URELEASE="precise"
MY_P="${P/session-/session_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Indicator showing session management, status and user switching used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-session"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-admin/packagekit[gtk,qt4]
	app-admin/packagekit-base[networkmanager,-nsplugin,policykit,udev]
	app-admin/system-config-printer-gnome
	>=dev-libs/glib-2.32
	>=dev-libs/libappindicator-99.12.10.0
	>=dev-libs/libdbusmenu-99.12.10.2[gtk]
	dev-libs/libindicate-qt
	>=gnome-extra/gnome-screensaver-99.3.4.1"


src_prepare() {
	# Fix '--disable-apt' configure switch #
	sed -e '/#include <libdbusmenu-glib\/client.h>/ a\#include <libdbusmenu-gtk\/menuitem.h>' \
		-i src/device-menu-mgr.c
}

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
	../configure --prefix=/usr \
		--with-gtk=2 \
		--disable-apt || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
	../configure --prefix=/usr \
		--with-gtk=3 \
		--disable-apt || die
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
