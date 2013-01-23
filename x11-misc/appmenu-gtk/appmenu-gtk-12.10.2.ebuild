EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/a/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/gtk-/gtk_}"

DESCRIPTION="Export GTK menus over DBus"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="unity-base/indicator-appmenu
	>=x11-libs/gtk+-99.2.24.11:2
	>=x11-libs/gtk+-99.3.6.0"

PATCHES=( "${WORKDIR}/${MY_P}-${UVER}.diff" )

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
	../configure --prefix=/usr \
		--sysconfdir=/etc \
		--disable-static \
		--with-gtk2 || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
	../configure --prefix=/usr \
		--sysconfdir=/etc \
		--disable-static || die
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

	exeinto /etc/X11/xinit/xinitrc.d
	doexe "${D}etc/X11/Xsession.d/80appmenu"
	doexe "${D}etc/X11/Xsession.d/80appmenu-gtk3"

	rm -rvf "${D}etc/X11/Xsession.d"
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
}
