EAPI=4

inherit base eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/l/${PN}"
UVER=""
URELEASE="precise"
MY_P="${P/integration-/integration_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Launchpad integration library to integrate launchpad URLs into the menus"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.tar.gz
	mirror://gentoo/mono.snk.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-dotnet/gtk-sharp:2
	>=dev-libs/glib-99.2.32.3
	dev-libs/gobject-introspection
	dev-python/pygtk"

src_prepare() {
	sed -i "/AssemblyKeyFile/ s@\".*\"@\"${WORKDIR}/mono.snk\"@g" lib/AssemblyInfo.cs
	sed -i '/configdir/ s@/cli@@g' Makefile.am Makefile.in
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
}
