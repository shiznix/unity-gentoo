EAPI=4
PYTHON_DEPEND="2:2.7 3:3.2"

inherit autotools flag-o-matic python ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/liba/${PN}"
URELEASE="raring"

DESCRIPTION="Library for single signon for the Unity desktop"
HOMEPAGE="http://code.google.com/p/accounts-sso/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
RESTRICT="mirror"

RDEPEND="dev-db/sqlite:3
	dev-libs/check
	dev-libs/dbus-glib
	>=dev-libs/glib-2.34
	>=dev-libs/gobject-introspection-1.34.2
	dev-libs/libxml2"
DEPEND="${RDEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	eautoreconf
	append-cflags -Wno-error
}

src_configure() {
	# Build PYTHON2 support #
	export EPYTHON="$(PYTHON -2)"
	[[ -d build-python2 ]] || mkdir build-python2
	pushd build-python2
		../configure --prefix=/usr ${myconf} \
			$(use_enable debug)
	popd

	# Build PYTHON3 support #
	export EPYTHON="$(PYTHON -3)"
	[[ -d build-python3 ]] || mkdir build-python3
	pushd build-python3
		../configure --prefix=/usr ${myconf} \
			$(use_enable debug)
	popd
}

src_compile() {
	# Build PYTHON2 support #
	export EPYTHON="$(PYTHON -2)"
	pushd build-python2
		emake || die
	popd

	# Build PYTHON3 support #
	export EPYTHON="$(PYTHON -3)"
	pushd build-python3
		emake || die
	popd
}

src_install() {
	# Install PYTHON2 support #
	export EPYTHON="$(PYTHON -2)"
	pushd build-python2
		emake DESTDIR="${D}" install || die
	popd

	# Install PYTHON3 support #
	export EPYTHON="$(PYTHON -3)"
	pushd build-python3
		emake DESTDIR="${D}" install || die
	popd

	rm -rf ${D}usr/doc
	prune_libtool_files --modules
}
