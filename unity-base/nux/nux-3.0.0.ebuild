EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/n/${PN}"
UVER="0ubuntu2"
URELEASE="quantal"
MY_P="${P/-/_}"

DESCRIPTION="Visual rendering toolkit for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"

SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!unity-base/utouch-geis
	app-i18n/ibus
	>=dev-libs/glib-99.2.32.3
	<media-libs/glew-1.8
	sys-devel/gcc:4.6
	unity-base/geis"

PATCHES=( "${WORKDIR}/${MY_P}-${UVER}.diff" )

pkg_pretend() {
	if [[ ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ) ]]; then
		die "${P} requires an active gcc:4.6, please consult the output of 'gcc-config -l'"
	fi
}

src_prepare() {
	# Fix building with libgeis #
	sed -e "s:libutouch-geis:libgeis:g" \
		-i configure \
			NuxGraphics/nux-graphics.pc.in
}
