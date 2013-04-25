EAPI=5
PYTHON_DEPEND="2:2.7 3:3.2"
SUPPORT_PYTHON_ABIS="1"

AUTOTOOLS_AUTORECONF=y

inherit autotools-utils eutils python ubuntu-versionator

MY_P="${PN}_${PV}"
S="${WORKDIR}/${PN}-${PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/d/${PN}"
URELEASE="raring"
UVER_PREFIX="~daily13.03.13.1"

DESCRIPTION="Provide objects allowing to create Model-View-Controller type programs across DBus"
HOMEPAGE="https://launchpad.net/dee/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

SLOT="0/4.2.1"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug examples +icu static-libs test"
RESTRICT="mirror"

RDEPEND="dev-libs/glib:2
	dev-libs/icu"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	test? ( dev-util/dbus-test-runner )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eautoreconf
	sed \
		-e '/GCC_FLAGS/s:-g::' \
		-e 's:vapigen:vapigen-0.14:g' \
		-i configure{,.ac} || die
	autotools-utils_src_prepare
}

src_configure() {
	# Build PYTHON2 support #
	export EPYTHON="$(PYTHON -2)"
	[[ -d build-python2 ]] || mkdir build-python2
	pushd build-python2
	../configure --prefix=/usr \
		$(use_enable debug trace-log) \
		$(use_enable test tests) \
		$(use_enable icu) \
		$(use_enable doc gtk-doc) || die
	popd

	# Build PYTHON3 support #
	export EPYTHON="$(PYTHON -3)"
	[[ -d build-python3 ]] || mkdir build-python3
	pushd build-python3
	../configure --prefix=/usr \
		$(use_enable debug trace-log) \
		$(use_enable test tests) \
		$(use_enable icu) \
		$(use_enable doc gtk-doc) || die
	popd
}

src_compile() {
        # Build PYTHON2 support #
        pushd build-python2
        	emake || die
        popd

        # Build PYTHON3 support #
        pushd build-python3
        	emake || die
        popd
}

src_install() {
        # Install PYTHON2 support #
        pushd build-python2
        	emake DESTDIR="${D}" install || die
        popd

        # Install PYTHON3 support #
        pushd build-python3
	        emake DESTDIR="${D}" install || die
        popd

	if use examples; then
		insinto /usr/share/doc/${PN}/
		doins -r examples
	fi

	prune_libtool_files --modules
}
