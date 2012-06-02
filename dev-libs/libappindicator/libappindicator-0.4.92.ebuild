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
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="vala"

DEPEND=">=dev-libs/libindicator-0.5.0
	dev-dotnet/gtk-sharp:2
	gnome-extra/zeitgeist[dbus,extensions,passiv,plugins]
	=x11-libs/gtk+-99.3.4.2
	vala? ( dev-lang/vala:0.14[vapigen] )"

MAKEOPTS="${MAKEOPTS} -j1"

src_configure() {
	use vala && \
		export VALAC=$(type -P valac-0.14) \
		export VALA_API_GEN=$(type -p vapigen-0.14)
	econf ${myconf} \
		--with-gtk=3
}
