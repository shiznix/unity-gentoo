EAPI=4
PYTHON_DEPEND="2:2.7 3:3.2"
SUPPORT_PYTHON_ABIS="1"
#RESTRICT_PYTHON_ABIS="3.*"

AUTOTOOLS_AUTORECONF=y

inherit base autotools-utils python

# Prefixing version with 99. so as not to break the overlay with upgrades in the main tree #
MY_PV="${PV/99./}"
MY_P="${PN}_${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/d/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"

DESCRIPTION="Provide objects allowing to create Model-View-Controller type programs across DBus"
HOMEPAGE="https://launchpad.net/dee/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
        ${UURL}/${MY_P}-${UVER}.diff.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug examples +icu static-libs test"

RDEPEND="dev-libs/glib:2
	dev-libs/icu"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	test? ( dev-util/dbus-test-runner )"

PATCHES=( "${WORKDIR}/${MY_P}-${UVER}.diff" )

src_prepare() {
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
}
