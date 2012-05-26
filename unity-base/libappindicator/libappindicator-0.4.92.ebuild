EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/liba/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/-/_}"

DESCRIPTION="Application indicators used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vala"

DEPEND="!dev-libs/libappindicator
	dev-dotnet/gtk-sharp:2
	x11-libs/gtk+:3
	vala? ( dev-lang/vala:0.14[vapigen] )"

src_configure() {
	use vala && \
		export VALAC=$(type -P valac-0.14) \
		export VALA_API_GEN=$(type -p vapigen-0.14)
	econf ${myconf} \
		--with-gtk=3
}
