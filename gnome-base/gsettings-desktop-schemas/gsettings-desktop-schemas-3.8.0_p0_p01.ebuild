EAPI="5"
GCONF_DEBUG="no"

inherit base gnome2 ubuntu-versionator

URELEASE=
UVER_PREFIX="~raring1"

DESCRIPTION="Collection of GSettings schemas for GNOME desktop patched for the Unity desktop"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="https://launchpad.net/~gnome3-team/+archive/gnome3/+files/${MY_P}.orig.tar.xz
	https://launchpad.net/~gnome3-team/+archive/gnome3/+files/${MY_P}-${UVER}${UVER_PREFIX}.debian.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+introspection"
#KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~sparc-solaris ~x86-solaris"
RESTRICT="mirror"

RDEPEND=">=dev-libs/glib-2.31:2
	>=x11-themes/gnome-backgrounds-3.8.1
	x11-themes/gtk-engines-unico
	>=x11-themes/light-themes-0.1.93[gtk3]
	x11-themes/ubuntu-themes
	introspection? ( >=dev-libs/gobject-introspection-1.31.0 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	PATCHES+=( "${FILESDIR}/nautilus_show_desktop_icons.diff" )

	base_src_prepare
	gnome2_src_prepare

	# Set Ambiance as the default window theme #
	sed -e 's:Adwaita:Ambiance:' \
		-i schemas/org.gnome.desktop.wm.preferences.gschema.xml.in.in \
			schemas/org.gnome.desktop.interface.gschema.xml.in.in
	# Set Ubuntu-mono-dark as the default icon theme #
	sed -e "s:'gnome':'ubuntu-mono-dark':" \
		-i schemas/org.gnome.desktop.interface.gschema.xml.in.in
}

src_configure() {
	G2CONF="${G2CONF}
		$(use_enable introspection)"
	DOCS="AUTHORS HACKING NEWS README"
	gnome2_src_configure
}
