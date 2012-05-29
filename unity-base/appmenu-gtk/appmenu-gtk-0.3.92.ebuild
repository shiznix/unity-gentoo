EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/a/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/gtk-/gtk_}"

DESCRIPTION="Export GTK menus over DBus"
HOMEPAGE="http://unity.ubuntu.com/" 
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="unity-base/indicator-appmenu
	=x11-libs/gtk+-99.3.4.2"

src_install() {
	base_src_install
	insinto /etc/X11/xinit/xinitrc.d
	doins "${D}etc/X11/Xsession.d/80appmenu-gtk3"
	rm -rvf "${D}etc/X11/Xsession.d"
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
}
