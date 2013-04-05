EAPI=4

inherit base eutils ubuntu-versionator

MY_P="${PN}_${PV}"
S="${WORKDIR}/${PN}-${PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libi/${PN}"
URELEASE="quantal"
UVER_PREFIX="daily13.02.25"

DESCRIPTION="A set of symbols and convenience functions that all indicators would like to use"
HOMEPAGE="https://launchpad.net/libindicator"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="3"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=x11-libs/gtk+-2.18:2
	>=x11-libs/gtk+-3.2:3
	x11-libs/libXfixes"
DEPEND="${RDEPEND}
        virtual/pkgconfig
        !<${CATEGORY}/${PN}-0.4.1-r201"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

export MAKEOPTS="${MAKEOPTS} -j1"

src_configure() {
	./autogen.sh
	make distclean

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

	prune_libtool_files --modules
}
