EAPI=4

inherit base eutils

# Prefixing version with 99. so as not to break the overlay with upgrades in the main tree #
MY_PV="${PV/99./}"   
MY_P="${PN}_${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libi/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"

DESCRIPTION="A set of symbols and convience functions that all indicators would like to use"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-99.2.24.10
	>=x11-libs/gtk+-99.3.4.2
	=x11-libs/libXfixes-5.0-r9999"
DEPEND="${RDEPEND}
        virtual/pkgconfig
        !<${CATEGORY}/${PN}-0.4.1-r201"

export MAKEOPTS="${MAKEOPTS} -j1"

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
	../configure --prefix=/usr \
		--enable-debug \
		--disable-static \
		--with-gtk=2 || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
	../configure --prefix=/usr \
		--enable-debug \
		--disable-static \
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
	emake -C libindicator DESTDIR="${D}" install || die
	emake -C tools DESTDIR="${D}" install || die
	popd
}
