EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libu/${PN}"
UVER="0ubuntu2"
URELEASE="precise"
MY_P="${P/misc-/misc_}"

DESCRIPTION="Miscellaneous modules for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=x11-libs/gtk+-99.3.4.2
	>=x11-libs/libXfixes-5.0-r9999"

src_prepare() {
        # Make docs optional #
	! use doc && \
		sed -e 's:unity-misc doc:unity-misc:' \
			-i Makefile.in
}
