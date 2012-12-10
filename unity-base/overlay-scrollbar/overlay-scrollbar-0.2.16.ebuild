EAPI=4

inherit autotools base eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/o/${PN}"
UVER="+r357-0ubuntu1"
URELEASE="quantal"
MY_P="${P/scrollbar-/scrollbar_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Ayatana Scrollbars use an overlay to ensure scrollbars take up no active screen real-estate"
HOMEPAGE="http://launchpad.net/ayatana-scrollbar"
SRC_URI="${UURL}/${MY_P}${UVER}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="gnome-base/dconf
	>=x11-libs/gtk+-99.2.24.11:2
	>=x11-libs/gtk+-99.3.4.2"

S="${WORKDIR}/${P}+r357"	

src_prepare() {
	eautoreconf
}

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

	# Only install overlay-scrollbar to provide the com.canonical.desktop.interface schema #
	# Don't make the scrollbar appear as it's annoying for many and quite buggy (misplaced, doesn't appear, causes apps to crash) #
	rm -rf ${D}usr/etc &> /dev/null
#	insinto /etc/X11/xinit/xinitrc.d/
#	doins data/81overlay-scrollbar	
}
