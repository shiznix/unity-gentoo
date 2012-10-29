# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/totem/totem-3.4.3.ebuild,v 1.5 2012/09/21 04:33:56 nirbheek Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes" # plugins are dlopened
WANT_AUTOMAKE="1.11"
PYTHON_DEPEND="python? 2:2.5"
PYTHON_USE_WITH="threads"
PYTHON_USE_WITH_OPT="python"
VALA_MIN_API_VERSION="0.14"

inherit gnome2 multilib python

DESCRIPTION="Media player for GNOME"
HOMEPAGE="http://projects.gnome.org/totem/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="doc flash grilo +introspection iplayer lirc nautilus nsplugin +python test
vala zeitgeist zeroconf"
#KEYWORDS="~amd64 ~x86 ~x86-fbsd"
KEYWORDS=""

# TODO:
# Cone (VLC) plugin needs someone with the right setup (remi ?)
# coherence plugin broken upstream
#
# FIXME: Automagic tracker-0.9.0
# Runtime dependency on gnome-session-2.91
RDEPEND=">=dev-libs/glib-2.27.92:2
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.3.6:3[introspection?]
	>=dev-libs/totem-pl-parser-2.32.4[introspection?]
	>=dev-libs/libpeas-1.1.0[gtk]
	>=x11-themes/gnome-icon-theme-2.16
	x11-libs/cairo
	>=dev-libs/libxml2-2.6:2
	>=media-libs/clutter-1.6.8:1.0
	media-libs/clutter-gst:2.0
	>=media-libs/clutter-gtk-1.0.2:1.0
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	x11-libs/mx:1.0

	media-libs/gst-plugins-good:1.0
	media-plugins/gst-plugins-taglib:1.0
	media-plugins/gst-plugins-gio:1.0
	media-plugins/gst-plugins-pango:1.0
	media-plugins/gst-plugins-soundtouch:1.0
	media-plugins/gst-plugins-x:1.0
	media-plugins/gst-plugins-meta:1.0

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXtst
	>=x11-libs/libXxf86vm-1.0.1

	gnome-base/gsettings-desktop-schemas
	x11-themes/gnome-icon-theme-symbolic

	flash? ( dev-libs/totem-pl-parser[quvi] )
	grilo? ( >=media-libs/grilo-0.1.16:0.1 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	lirc? ( app-misc/lirc )
	nautilus? ( >=gnome-base/nautilus-2.91.3 )
	nsplugin? (
		>=dev-libs/dbus-glib-0.82
		>=x11-misc/shared-mime-info-0.22 )
	python? (
		>=dev-libs/gobject-introspection-0.6.7
		>=dev-python/pygobject-2.90.3:3
		>=x11-libs/gtk+-2.91.7:3[introspection]
		dev-python/pyxdg
		dev-python/gst-python:0.10
		dev-python/dbus-python
		iplayer? (
			dev-python/httplib2
			dev-python/feedparser
			dev-python/beautifulsoup ) )
	zeitgeist? ( dev-libs/libzeitgeist )
	zeroconf? ( >net-libs/libepc-0.4.0 )"
# XXX: zeroconf requires unreleased version of libepc

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.5
	>=app-text/gnome-doc-utils-0.20.3
	app-text/scrollkeeper
	>=dev-util/intltool-0.40
	sys-devel/gettext
	x11-proto/xextproto
	x11-proto/xproto
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.14 )
	test? ( python? ( dev-python/pylint ) )"
# Only needed when regenerating C sources from Vala files
#	vala? ( $(vala_depend) )"
# docbook-xml-dtd is needed for user doc

# see bug #359379
REQUIRED_USE="flash? ( nsplugin )
	python? ( introspection )
	zeitgeist? ( introspection vala )"

# XXX: pylint checks fail because of bad code
RESTRICT="test"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	use nsplugin && DOCS="${DOCS} browser-plugin/README.browser-plugin"
	G2CONF="${G2CONF}
		--disable-run-in-source-tree
		--disable-schemas-compile
		--disable-scrollkeeper
		--disable-static
		--with-smclient=auto
		--enable-easy-codec-installation
		$(use_enable flash vegas-plugin)
		$(use_enable introspection)
		$(use_enable nautilus)
		$(use_enable nsplugin browser-plugins)
		$(use_enable python)
		$(use_enable vala)
		VALAC=$(type -P true)
		BROWSER_PLUGIN_DIR=/usr/$(get_libdir)/nsbrowser/plugins"
		# Only needed when regenerating C sources from Vala files
		#VALAC=$(type -P valac-$(vala_best_api_version))

	if ! use test; then
		# pylint is checked unconditionally, but is only used for make check
		G2CONF="${G2CONF} PYLINT=$(type -P true)"
	fi
	#--with-smclient=auto needed to correctly link to libICE and libSM

	# Disabled: sample-python, sample-vala
	local plugins="brasero-disc-recorder,chapters,im-status,gromit"
	plugins+=",media-player-keys,ontop,properties,screensaver"
	plugins+=",screenshot,sidebar-test,skipto"
	use grilo && plugins+=",grilo"
	use iplayer && plugins+=",iplayer"
	use lirc && plugins+=",lirc"
	use nautilus && plugins+=",save-file"
	use python && plugins+=",dbusservice,pythonconsole,opensubtitles"
	use vala && plugins+=",rotation"
	use zeitgeist && plugins+=",zeitgeist-dp"
	use zeroconf && plugins+=",publish"

	G2CONF="${G2CONF} --with-plugins=${plugins}"

	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# AC_CONFIG_AUX_DIR_DEFAULT doesn't exist, and eautoreconf/aclocal fails
	mkdir -p m4

	#if [[ ${PV} != 9999 ]]; then
	#	intltoolize --force --copy --automake || die "intltoolize failed"
	#	eautoreconf
	#fi

	use python && python_clean_py-compile_files
	# Only needed when regenerating C sources from Vala files
	#use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# Work around sandbox violations when FEATURES=-userpriv (bug #358755)
	unset DISPLAY
	gnome2_src_configure
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use python; then
		python_need_rebuild
		python_mod_optimize /usr/$(get_libdir)/totem/plugins
	fi

	ewarn
	ewarn "If totem doesn't play some video format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn
}

pkg_postrm() {
	gnome2_pkg_postrm
	use python && python_mod_cleanup /usr/$(get_libdir)/totem/plugins
}
