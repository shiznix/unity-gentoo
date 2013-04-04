EAPI=4

inherit base eutils ubuntu-versionator

MY_P="${PN}_${PV}"
S="${WORKDIR}/${PN}-${PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/liba/${PN}"
URELEASE="quantal"

DESCRIPTION="Application indicators used by the Unity desktop"
HOMEPAGE="https://launchpad.net/libappindicator"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="vala"
RESTRICT="mirror"

DEPEND="dev-libs/libindicator:3
	dev-dotnet/gtk-sharp:2
	dev-libs/dbus-glib
	dev-libs/xapian-bindings[python]
	dev-perl/XML-LibXML
	dev-python/dbus-python
	dev-python/pygobject:2
	dev-python/pygtk
	dev-python/pyxdg
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	vala? ( dev-lang/vala:0.14[vapigen] )"

src_prepare () {
	export MAKEOPTS="${MAKEOPTS} -j1"
	use vala && \
		export VALAC=$(type -P valac-0.14) \
		export VALA_API_GEN=$(type -p vapigen-0.14)
}

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
	../configure --prefix=/usr \
		--disable-static \
		--with-gtk=2 || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
	../configure --prefix=/usr \
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
	make -C src DESTDIR="${D}" install || die
	if use vala; then
		make -C bindings/vala DESTDIR="${D}" install || die
	fi
	popd
}
