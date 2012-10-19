EAPI="4"
GCONF_DEBUG="yes"
CLUTTER_LA_PUNT="yes"

# inherit clutter after gnome2 so that defaults aren't overriden
# inherit gnome.org in the end so we use gnome mirrors and get the xz tarball
# no PYTHON_DEPEND, python2 is just a build-time dependency
inherit python gnome2 clutter gnome.org

DESCRIPTION="GStreamer Integration library for Clutter"

SLOT="2.0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~x86"
IUSE="doc examples +introspection"

# FIXME: Support for gstreamer-basevideo-0.10 (HW decoder support) is automagic
RDEPEND="
	>=dev-libs/glib-2.20:2
	>=media-libs/clutter-1.6.0:1.0[introspection?]
	>=media-libs/cogl-1.8:1.0[introspection?]
	>=media-libs/gstreamer-1.0.1:1.0[introspection?]
	>=media-libs/gst-plugins-bad-1.0.1:1.0
	media-libs/gst-plugins-base:1.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.6.8 )"
DEPEND="${RDEPEND}
	=dev-lang/python-2*
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.8 )"
# eautoreconf does *not* need gtk-doc-am, see build/autotools/ directory

pkg_setup() {
	DOCS="AUTHORS NEWS README"
	EXAMPLES="examples/{*.c,*.png,README}"
	G2CONF="${G2CONF}
		--disable-maintainer-flags
		$(use_enable introspection)"

	python_set_active_version 2
	python_pkg_setup
}

src_configure() {
	econf \
		--with-html-dir=/usr/share/gtk-doc/html/${PN}-${SLOT}
}

src_compile() {
	# Clutter tries to access dri without userpriv, upstream bug #661873
	# Massive failure of a hack, see bug 360219, bug 360073, bug 363917
	unset DISPLAY
	default
}
