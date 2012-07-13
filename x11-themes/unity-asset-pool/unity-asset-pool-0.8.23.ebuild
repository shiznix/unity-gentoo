EAPI=4

inherit eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu1"
URELEASE="precise"
MY_P="${P/pool-/pool_}"

DESCRIPTION="Unity desktop icon theme"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=x11-themes/gnome-icon-theme-3.4.0
	x11-themes/hicolor-icon-theme"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.19
	>=sys-devel/gettext-0.15"

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	insinto /usr/share/unity/themes
	doins -r launcher/* panel/*

	insinto /usr/share/icons
	doins -r unity-icon-theme

	dodoc COPYRIGHT
}
