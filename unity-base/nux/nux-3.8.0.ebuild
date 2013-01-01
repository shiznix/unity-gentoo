EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/n/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/-/_}"

DESCRIPTION="Visual rendering toolkit for the Unity desktop"
HOMEPAGE="http://launchpad.net/nux"

SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug examples tests"

DEPEND="!unity-base/utouch-geis
	app-i18n/ibus
	>=dev-libs/glib-2.32.3
	<media-libs/glew-1.8
	>=sys-devel/gcc-4.6
	unity-base/geis"

PATCHES=( "${WORKDIR}/${MY_P}-${UVER}.diff" )

src_prepare() {
	if [[ ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ) ]]; then
		die "${P} requires an active >=gcc:4.6, please consult the output of 'gcc-config -l'"
	fi

	epatch -p1 "${WORKDIR}/${MY_P}-${UVER}.diff" # This needs to be applied for the debian/ directory to be present #
	for patch in $(cat "debian/patches/series" | grep -v '#'); do
		PATCHES+=( "debian/patches/${patch}" )
	done
	base_src_prepare

	# Fix building with libgeis #
	sed -e "s:libutouch-geis:libgeis:g" \
		-i configure \
			NuxGraphics/nux-graphics.pc.in
}

src_configure() {
	use debug && \
		myconf="${myconf}
			--enable-debug=yes"
	! use examples && \
		myconf="${myconf}
			--enable-examples=no"
	! use tests && \
		myconf="${myconf}
			--enable-tests=no
			--enable-gputests=no"
	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die
	dosym /usr/libexec/unity_support_test /usr/lib/nux/unity_support_test
}
