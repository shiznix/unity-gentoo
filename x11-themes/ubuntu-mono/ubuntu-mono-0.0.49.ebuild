EAPI=4
PYTHON_DEPEND="2:2.7"
#SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="1"

inherit autotools eutils gnome2 python

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER=""
URELEASE="quantal-updates"
MY_P="${P/mono-/mono_}"

DESCRIPTION="Unity desktop default icon theme"
HOMEPAGE="unity.ubuntu.com"
SRC_URI="${UURL}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

S="${WORKDIR}/${PN}-0.0.39"

RDEPEND=">=x11-themes/hicolor-icon-theme-0.10"
DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	python_set_active_version 2
}

src_configure() {
	:
}

src_compile() {
	emake
}

src_install() {
	dodir /usr/share/icons/
	insinto /usr/share/icons
	doins -r LoginIcons ubuntu-mono-dark ubuntu-mono-light
}
