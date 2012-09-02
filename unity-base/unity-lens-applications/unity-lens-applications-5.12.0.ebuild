EAPI=4

inherit base eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu1"
URELEASE="precise-updates"
MY_P="${P/applications-/applications_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Application lens for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/vala:0.16[vapigen]
	dev-libs/libzeitgeist
	>=gnome-base/gnome-menus-3.0.1-r1:0
	sys-libs/db:5.1
	unity-base/unity"

src_prepare() {
	# Alter source to work with Gentoo's sys-libs/db slots #
	sed -e 's:"db.h":"db5.1/db.h":g' \
		-i configure || die
	sed -e 's:-ldb$:-ldb-5.1:g' \
		-i src/* || die
	sed -e 's:<db.h>:<db5.1/db.h>:g' \
		-i src/* || die
}

src_configure() {
	export VALAC=$(type -P valac-0.16)
	export VALA_API_GEN=$(type -p vapigen-0.16)
	econf
}
