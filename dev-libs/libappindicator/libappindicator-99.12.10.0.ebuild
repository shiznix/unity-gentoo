EAPI=4

inherit base eutils

# Prefixing version with 99. so as not to break the overlay with upgrades in the main tree #
MY_PV="${PV/99./}"
MY_P="${PN}_${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/liba/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"

DESCRIPTION="Application indicators used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="vala"
RESTRICT="mirror"

DEPEND=">=dev-libs/libindicator-99.0.5.0:3
	dev-dotnet/gtk-sharp:2
	dev-libs/xapian-bindings[python]
	dev-python/dbus-python
	dev-python/pygobject:2
	dev-python/pyxdg
	gnome-extra/zeitgeist[dbus,extensions,fts,passiv,plugins]
	gnome-extra/zeitgeist-datasources[telepathy]
	gnome-extra/zeitgeist-extensions[geolocation]
	>=x11-libs/gtk+-99.2.24.10:2
	>=x11-libs/gtk+-99.3.6.0:3
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
