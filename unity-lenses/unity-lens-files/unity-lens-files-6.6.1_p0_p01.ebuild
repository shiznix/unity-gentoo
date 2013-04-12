EAPI=4
GNOME2_LA_PUNT="yes"

inherit base eutils gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
URELEASE="quantal-updates"

DESCRIPTION="Application lens for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-files"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

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

DEPEND="dev-lang/vala:0.16[vapigen]
	dev-libs/libzeitgeist
	gnome-extra/zeitgeist[dbus,fts,-passiv]
	gnome-extra/zeitgeist-datahub
	unity-base/unity
	unity-lenses/unity-lens-applications"

src_configure() {
	export VALAC=$(type -P valac-0.16)
	export VALA_API_GEN=$(type -p vapigen-0.16)
	econf
}
