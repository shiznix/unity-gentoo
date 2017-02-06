# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python{3_4,3_5} )
WANT_AUTOMAKE=1.14

URELEASE="yakkety"
inherit autotools gnome2-utils python-any-r1 virtualx ubuntu-versionator vala

UURL="mirror://unity/pool/universe/e/${PN}"

DESCRIPTION="Telepathy instant messaging and video/audio call client for GNOME patched for the Unity desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Empathy"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-2 CC-BY-SA-3.0 FDL-1.3 LGPL-2.1"
SLOT="0"
IUSE="debug +geoloc gnome +gnome-online-accounts +map spell test +v4l"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

# False positives caused by nested configure scripts
QA_CONFIGURE_OPTIONS=".*"

# gdk-pixbuf and pango extensively used in libempathy-gtk
COMMON_DEPEND="
	>=dev-libs/glib-2.37.6:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.9.4:3
	x11-libs/pango
	>=dev-libs/dbus-glib-0.51
	>=dev-libs/folks-0.9.5:=[telepathy]
	dev-libs/libgee:0.8=
	>=app-crypt/libsecret-0.5
	>=media-libs/libcanberra-0.25[gtk3]
	>=net-libs/gnutls-2.8.5:=
	>=net-libs/webkit-gtk-1.9.1:3
	>=x11-libs/libnotify-0.7:=

	media-libs/gstreamer:1.0
	>=media-libs/clutter-1.10.0:1.0
	>=media-libs/clutter-gtk-1.1.2:1.0
	media-libs/clutter-gst:2.0
	>=media-libs/cogl-1.14:1.0=

	net-libs/farstream:0.2=
	>=net-libs/telepathy-farstream-0.6.0:=
	>=net-libs/telepathy-glib-0.23.2
	>=net-im/telepathy-logger-0.8.0:=

	app-crypt/gcr
	dev-libs/libxml2:2
	gnome-base/gsettings-desktop-schemas
	media-sound/pulseaudio[glib]
	net-libs/libsoup:2.4
	x11-libs/libX11

	geoloc? (
		>=app-misc/geoclue-2.1:2.0
		>=sci-geosciences/geocode-glib-3.10 )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.5.1[uoa] )
	map? (
		>=media-libs/clutter-1.7.14:1.0
		>=media-libs/clutter-gtk-0.90.3:1.0
		>=media-libs/libchamplain-0.12.1:0.12[gtk] )
	spell? (
		>=app-text/enchant-1.2
		>=app-text/iso-codes-0.35 )
	v4l? (
		media-plugins/gst-plugins-v4l2:1.0
		>=media-video/cheese-3.4:=
		virtual/libgudev:= )
"

# >=empathy-3.4 is incompatible with telepathy-rakia-0.6, bug #403861
RDEPEND="${COMMON_DEPEND}
	media-libs/gst-plugins-base:1.0
	net-im/telepathy-connection-managers
	!<net-voip/telepathy-rakia-0.7
	x11-themes/gnome-icon-theme-symbolic
	gnome? ( gnome-extra/gnome-contacts )
"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=dev-util/intltool-0.50.0
	virtual/pkgconfig
	net-libs/account-plugins
	test? (
		sys-apps/grep
		>=dev-libs/check-0.9.4 )
	$(vala_depend)
"
PDEPEND=">=net-im/telepathy-mission-control-5.14"

pkg_setup() {
	python-any-r1_pkg_setup
	export PYTHONIOENCODING=UTF-8 # See bug 489774
}

src_prepare() {
	# Disable selected patches #
	sed \
		`# Supposedly to "Add Unity support to show file transfer progress in the launcher" but does not work #` \
		`#  causes empathy process to hang, no chat windows displayed and consumes 100% CPU #` \
			-e 's:41_unity_launcher_progress.patch:#41_unity_launcher_progress.patch:g' \
				-i "${WORKDIR}/debian/patches/series"
	ubuntu-versionator_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}

src_configure() {
	DOCS="CONTRIBUTORS AUTHORS ChangeLog NEWS README"
	econf
		--disable-Werror \
		--disable-coding-style-checks \
		--disable-static \
		--enable-ubuntu-online-accounts=yes \
		--enable-libunity=yes \
		--enable-gst-1.0 \
		$(use_enable debug) \
		$(use_enable geoloc geocode) \
		$(use_enable geoloc location) \
		$(use_enable gnome-online-accounts goa) \
		$(use_enable map) \
		$(use_enable spell) \
		$(use_enable v4l gudev) \
		$(use_with v4l cheese) \
		ITSTOOL=$(type -P true)
}

src_test() {
	dbus-launch Xemake check #504516
}

src_install() {
	emake DESTDIR="${ED}" install
	dodoc CONTRIBUTORS AUTHORS ChangeLog NEWS README
}

pkg_preinst() {
	gnome2_schemas_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
