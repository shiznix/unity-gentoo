EAPI=4
PYTHON_DEPEND="2:2.7 3:3.2"
SUPPORT_PYTHON_ABIS="1"
#RESTRICT_PYTHON_ABIS="3.*"

inherit base eutils autotools python

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libu/${PN}"
UVER="0ubuntu2"
URELEASE="quantal"
MY_P="${P/-/_}"

DESCRIPTION="Essential libraries needed for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/dee-1.0.14
	>=dev-libs/libdbusmenu-99.12.10.2[gtk]
	dev-libs/libgee:0
	dev-lang/vala:0.16"

src_prepare() {
	export VALAC=$(type -P valac-0.16) && \
	export VALA_API_GEN=$(type -p vapigen-0.16)

	epatch -p1 "${WORKDIR}/${MY_P}-${UVER}.diff"

	for patch in $(cat "debian/patches/series" | grep -v '#'); do
		PATCHES+=( "debian/patches/${patch}" )
	done
	base_src_prepare
}

src_configure() {
        # Build PYTHON2 support #
	export EPYTHON="$(PYTHON -2)"
        [[ -d build-python2 ]] || mkdir build-python2
        pushd build-python2
	../configure --prefix=/usr || die
        popd

        # Build PYTHON3 support #
	export EPYTHON="$(PYTHON -3)"
        [[ -d build-python3 ]] || mkdir build-python3
        pushd build-python3
	../configure --prefix=/usr || die
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
}
