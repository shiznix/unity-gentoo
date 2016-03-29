# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

URELEASE="wily"
inherit base eutils autotools mono-env fdo-mime gnome2-utils versionator ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/b/${PN}"
UVER_PREFIX="+really2.6.2"

DESCRIPTION="Import, organize, play, and share your music (patched for Unity)"
HOMEPAGE="http://banshee.fm/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.xz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+aac +cdda +bpm daap doc +encode ipod karma mtp test udev +web youtube"
RESTRICT="mirror"

RDEPEND="
	>=dev-lang/mono-2.4.3
	gnome-base/gnome-settings-daemon
	sys-apps/dbus
	>=dev-dotnet/gtk-sharp-2.12:2
	>=dev-dotnet/notify-sharp-0.4.0_pre20080912-r1
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/gst-plugins-bad:1.0
	media-libs/gst-plugins-good:1.0
	media-libs/gst-plugins-ugly:1.0
	media-plugins/gst-plugins-meta:1.0
	>=dev-dotnet/gconf-sharp-2.24.0:2
	cdda? (
		|| (
			media-plugins/gst-plugins-cdparanoia:1.0
			media-plugins/gst-plugins-cdio:1.0
		)
	)
	media-libs/musicbrainz:3
	dev-dotnet/dbus-sharp
	dev-dotnet/dbus-sharp-glib
	>=dev-dotnet/mono-addins-0.6.2[gtk]
	>=dev-dotnet/taglib-sharp-2.0.3.7
	>=dev-db/sqlite-3.4:3
	karma? ( >=media-libs/libkarma-0.1.0-r1 )
	aac? ( media-plugins/gst-plugins-faad:1.0 )
	bpm? ( media-plugins/gst-plugins-soundtouch:1.0 )
	daap? (	>=dev-dotnet/mono-zeroconf-0.8.0-r1 )
	doc? (
		>=app-text/gnome-doc-utils-0.17.3
	)
	encode? (
		media-plugins/gst-plugins-lame:1.0
		media-plugins/gst-plugins-taglib:1.0
	)
	ipod? ( >=media-libs/libgpod-0.8.2[mono] )
	mtp? (
		>=media-libs/libmtp-0.3.0
	)
	web? (
		>=net-libs/webkit-gtk-1.2.2:2
		>=net-libs/libsoup-gnome-2.26:2.4
	)
	youtube? (
		>=dev-dotnet/google-gdata-sharp-1.4
	)
	udev? (
		app-misc/media-player-info
		dev-dotnet/gudev-sharp
		dev-dotnet/gkeyfile-sharp
		dev-dotnet/gtk-sharp-beans
		dev-dotnet/gio-sharp
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
S="${WORKDIR}/${PN}-2.6.2"

src_prepare () {
	# remove dedirection over ubuntu servers since it doesn't work any more
	sed -i '/Change-Amazon-redirect-url/d' "${WORKDIR}/debian/patches/series" || die
	ubuntu-versionator_src_prepare

	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	# Don't build BPM extension when not wanted
	if ! use bpm; then
		sed -i -e 's:Banshee.Bpm:$(NULL):g' src/Extensions/Makefile.am || die
	fi

	# Don't append -ggdb, bug #458632, upstream bug #698217
	sed -i -e 's:-ggdb3:$(NULL):g' libbanshee/Makefile.am || die
	sed -i -e 's:-ggdb3::g' src/Core/Banshee.WebBrowser/libossifer/Makefile.am || die

	AT_M4DIR="-I build/m4/banshee -I build/m4/shamrock -I build/m4/shave" \
	eautoreconf
}

src_configure() {
	# soundmenu needs a properly maintained and updated indicate-sharp
	local myconf="--disable-dependency-tracking
		--disable-static
		--disable-maintainer-mode
		--enable-gnome
		--enable-schemas-install
		--with-gconf-schema-file-dir=/etc/gconf/schemas
		--with-vendor-build-id=Gentoo/${PN}/${PVR}
		--disable-boo
		--disable-clutter
		--disable-gst-sharp
		--disable-torrent
		--disable-shave
		--enable-meego
		--disable-ubuntuone
		--enable-soundmenu
		--disable-upnp"

	econf \
		$(use_enable doc docs) \
		$(use_enable doc user-help) \
		$(use_enable mtp) \
		$(use_enable daap) \
		$(use_enable ipod appledevice) \
		$(use_enable karma) \
		$(use_enable web webkit) \
		$(use_enable youtube) \
		$(use_enable udev gio) \
		$(use_enable udev gio_hardware) \
		${myconf}
}

src_compile() {
	emake MCS=/usr/bin/gmcs
}

src_install() {
	default
	prune_libtool_files --all
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
