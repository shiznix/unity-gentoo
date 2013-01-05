EAPI=4
PYTHON_DEPEND="2:2.7 3:3.2"
SUPPORT_PYTHON_ABIS="1"

AUTOTOOLS_AUTORECONF=y

inherit autotools-utils

# Prefixing version with 99. so as not to break the overlay with upgrades in the main tree #
MY_PV="${PV/99./}"
MY_P="${PN}_${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/d/${PN}"
UVER="0ubuntu1.1"
URELEASE="quantal-updates"

DESCRIPTION="Provide objects allowing to create Model-View-Controller type programs across DBus"
HOMEPAGE="https://launchpad.net/dee/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
        ${UURL}/${MY_P}-${UVER}.diff.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug examples +icu static-libs test"

RDEPEND="
	dev-libs/glib:2
	dev-libs/icu"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	test? (
		dev-libs/gtx
		dev-util/dbus-test-runner
		)"

PATCHES=( "${WORKDIR}/${MY_P}-${UVER}.diff" )

src_prepare() {
	sed \
		-e '/GCC_FLAGS/s:-g::' \
		-e 's:vapigen:vapigen-0.14:g' \
		-i configure.ac || die
	echo true > py-compile || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-silent-rules
		$(use_enable debug trace-log)
		$(use_enable test tests)
		$(use_enable test extended-tests)
		$(use_enable icu)
		$(use_enable doc gtk-doc)
		)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	if use examples; then
		insinto /usr/share/doc/${PN}/
		doins -r examples
	fi
}
