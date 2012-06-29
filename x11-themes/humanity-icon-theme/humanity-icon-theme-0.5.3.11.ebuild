EAPI="4"
GCONF_DEBUG="no"

inherit gnome2 eutils autotools

DESCRIPTION="Unity desktop default icon theme"
HOMEPAGE="unity.ubuntu.com"

SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/h/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

S="${WORKDIR}/${PN}"

RDEPEND=">=x11-themes/hicolor-icon-theme-0.10"
DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	dodir /usr/share/icons/
	insinto /usr/share/icons
	doins -r Humanity Humanity-Dark
}
