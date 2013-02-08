EAPI=4

GNOME2_LA_PUNT="yes"

inherit eutils gnome2 ubuntu-versionator

URELEASE="quantal-updates"

DESCRIPTION="Simple backup tool using duplicity back-end"
HOMEPAGE="https://launchpad.net/deja-dup/"
SRC_URI="http://launchpad.net/${PN}/26/${PV}/+download/${PN}-${PV}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nautilus"

RESTRICT="test"

COMMON_DEPEND="
	app-crypt/libsecret[vala]
	dev-libs/glib:2
	dev-libs/libpeas
	gnome-base/gnome-control-center
	x11-libs/gtk+:3
	x11-libs/libnotify

	app-backup/duplicity
	dev-libs/dbus-glib

	nautilus? ( gnome-base/nautilus )"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gvfs[fuse]"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-lang/vala:0.16
	dev-perl/Locale-gettext
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"


src_prepare() {
	DOCS="NEWS AUTHORS"
	G2CONF="${G2CONF}
		$(use_with nautilus)
		--with-ccpanel
		--with-unity
		--disable-static"
	export VALAC=$(type -p valac-0.16)

	gnome2_src_prepare
}
