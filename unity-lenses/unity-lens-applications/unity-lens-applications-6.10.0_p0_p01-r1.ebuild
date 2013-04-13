EAPI=4
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.03.06"

DESCRIPTION="Application lens for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-applications"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=dev-libs/dee-1.0.14
	dev-libs/libunity"

# gnome-extra/zeitgeist has circular dependencies when 'passiv' USE flag is enabled
# * Error: circular dependencies:
#
# (gnome-extra/zeitgeist-datahub-0.9.5::gentoo, ebuild scheduled for merge) depends on
#  (dev-libs/libzeitgeist-0.3.18::gentoo, ebuild scheduled for merge) (buildtime)
#   (gnome-extra/zeitgeist-0.9.5::gentoo, ebuild scheduled for merge) (runtime)
#    (gnome-extra/zeitgeist-datahub-0.9.5::gentoo, ebuild scheduled for merge) (buildtime)

# 'passiv' USE flag does nothing but pull in gnome-extra/zeitgeist-datahub as an RDEPEND
#       so to workaround, add gnome-extra/zeitgeist-datahub to DEPEND list and specify
#               gnome-extra/zeitgeist[-passiv]

DEPEND="${RDEPEND}
	dev-libs/libcolumbus
	dev-lang/vala:0.18[vapigen]
	dev-libs/libzeitgeist
	>=gnome-base/gnome-menus-3.0.1-r1:0
	gnome-extra/zeitgeist[dbus,fts,-passiv]
	gnome-extra/zeitgeist-datahub
	sys-libs/db:5.1
	unity-base/unity"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	eautoreconf
	export VALAC=$(type -P valac-0.18)
	export VALA_API_GEN=$(type -p vapigen-0.18)
	# Alter source to work with Gentoo's sys-libs/db slots #
	sed -e 's:"db.h":"db5.1/db.h":g' \
		-i configure || die
	sed -e 's:-ldb$:-ldb-5.1:g' \
		-i src/* || die
	sed -e 's:<db.h>:<db5.1/db.h>:g' \
		-i src/* || die
}
