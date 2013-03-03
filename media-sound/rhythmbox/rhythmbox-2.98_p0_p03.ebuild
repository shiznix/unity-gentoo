EAPI="4"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="python? 2:2.5"
PYTHON_USE_WITH="xml"
PYTHON_USE_WITH_OPT="python"

inherit autotools base eutils gnome2 python multilib ubuntu-versionator virtualx

UURL="http://archive.ubuntu.com/ubuntu/pool/main/r/${PN}"
URELEASE="raring"

DESCRIPTION="Music management and playback software for GNOME patched for the Unity desktop"
HOMEPAGE="http://www.rhythmbox.org/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="cdr daap dbus gnome-keyring html ipod libnotify lirc mtp nsplugin +python test +udev upnp-av webkit zeitgeist"
# vala
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
RESTRICT="mirror"

REQUIRED_USE="
	ipod? ( udev )
	mtp? ( udev )
	dbus? ( python )
	gnome-keyring? ( python )
	webkit? ( python )"

# FIXME: double check what to do with fm-radio plugin
# NOTE: gst-python is still needed because gstreamer introspection is incomplete
COMMON_DEPEND=">=dev-libs/glib-2.28.0:2
	>=dev-libs/libxml2-2.7.8:2
	>=x11-libs/gtk+-3.2:3[introspection]
	>=x11-libs/gdk-pixbuf-2.18.0:2
	>=dev-libs/gobject-introspection-0.10.0
	>=dev-libs/libpeas-0.7.3[gtk,python?]
	>=dev-libs/totem-pl-parser-3.4
	>=net-libs/libsoup-2.26:2.4
	>=net-libs/libsoup-gnome-2.26:2.4
	>=media-libs/gst-plugins-base-0.10.32:0.10[introspection]
	>=media-libs/gstreamer-0.10.32:0.10[introspection]
	>=sys-libs/tdb-1.2.6
	dev-libs/json-glib

	cdr? ( >=app-cdr/brasero-3.4 )
	daap? (
		>=net-libs/libdmapsharing-2.9.11:3.0
		>=net-dns/avahi-0.6 )
	gnome-keyring? ( >=gnome-base/gnome-keyring-0.4.9 )
	html? ( <net-libs/webkit-gtk-1.10:3 )
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
	lirc? ( app-misc/lirc )
	media-libs/libdiscid
	|| ( >=media-libs/musicbrainz-4.0.0:4
		     >=media-libs/musicbrainz-3.0.2:3 )
	gnome-base/gconf:2
	python? ( dev-python/pygobject:3 )
	udev? (
		virtual/udev[gudev]
		ipod? ( >=media-libs/libgpod-0.7.92[udev] )
		mtp? ( >=media-libs/libmtp-0.3 ) )
	zeitgeist? ( gnome-extra/zeitgeist )
"
RDEPEND="${COMMON_DEPEND}
	>=media-plugins/gst-plugins-soup-0.10:0.10
	>=media-plugins/gst-plugins-libmms-0.10:0.10
	|| (
		>=media-plugins/gst-plugins-cdparanoia-0.10:0.10
		>=media-plugins/gst-plugins-cdio-0.10:0.10 )
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	>=media-plugins/gst-plugins-taglib-0.10.6:0.10
	x11-themes/gnome-icon-theme-symbolic
	upnp-av? (
		>=media-libs/grilo-0.1.17:0.1
		>=media-plugins/grilo-plugins-0.1.17:0.1[upnp-av] )
	python? (
		>=dev-python/gst-python-0.10.8:0.10

		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]

		dbus? ( sys-apps/dbus )
		gnome-keyring? ( dev-python/gnome-keyring-python )
		webkit? (
			dev-python/mako
			<net-libs/webkit-gtk-1.10:3[introspection] ) )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.9.1
	test? ( dev-libs/check )"
#	vala? ( >=dev-lang/vala-0.9.4:0.12 )
DOCS="AUTHORS ChangeLog DOCUMENTERS INTERNALS \
	  MAINTAINERS MAINTAINERS.old NEWS README THANKS"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
		G2CONF="${G2CONF} PYTHON=$(PYTHON -2)"
	fi

	# --enable-vala just installs the sample vala plugin, and the configure
	# checks are broken, so don't enable it
	G2CONF="${G2CONF}
		MOZILLA_PLUGINDIR=/usr/$(get_libdir)/nsbrowser/plugins
		VALAC=$(type -P valac-0.14)
		--enable-mmkeys
		--disable-more-warnings
		--disable-schemas-compile
		--disable-static
		--disable-vala
		--without-hal
		$(use_enable daap)
		$(use_enable libnotify)
		$(use_enable lirc)
		$(use_enable nsplugin browser-plugin)
		$(use_enable python)
		$(use_enable upnp-av grilo)
		$(use_with cdr brasero)
		$(use_with daap mdns avahi)
		$(use_with gnome-keyring)
		$(use_with html webkit)
		$(use_with ipod)
		$(use_with mtp)
		$(use_with udev gudev)"

	export GST_INSPECT=/bin/true
}

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
	eautoreconf

	gnome2_src_prepare
	use python && python_clean_py-compile_files
}

src_test() {
	unset SESSION_MANAGER
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "test failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use python; then
		python_need_rebuild
		python_mod_optimize /usr/$(get_libdir)/rhythmbox/plugins
	fi

	ewarn
	ewarn "If ${PN} doesn't play some music format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn
}

pkg_postrm() {
	gnome2_pkg_postrm
	use python && python_mod_cleanup /usr/$(get_libdir)/rhythmbox/plugins
}
