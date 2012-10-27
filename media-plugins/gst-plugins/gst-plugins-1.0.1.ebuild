EAPI=4

inherit flag-o-matic

DESCRIPTION="Plugins package for gstreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"
SRC_URI="http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${PV}.tar.xz
	http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-good-${PV}.tar.xz
	http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-bad-${PV}.tar.xz
	http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-ugly-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"

IUSE_GST_PLUGINS="
        gst_plugins_a52dec
        gst_plugins_alsa
        gst_plugins_cdparanoia
        gst_plugins_dts
        gst_plugins_libdv
        gst_plugins_dvb
        gst_plugins_dvdread
        gst_plugins_faad
        gst_plugins_flac
        gst_plugins_gio
        gst_plugins_gnomevfs
        gst_plugins_jack
        gst_plugins_jpeg
        gst_plugins_lame

"
GST_PLUGINS_BASE="x xvideo xshm alsa cdparanoia gnomevfs gio libvisual ogg theora ivorbis vorbis pango"
GST_PLUGINS_GOOD="gconftool zlib bz2 directsound oss oss4 sunaudio osx_audio osx_video gst_v4l2
			x xshm xvideo aalib annodex cairo esd flac gconf gdk_pixbuf hal jack jpeg
			libcaca libdv libpng pulse dv1394 shout2 soup speex taglib vpx wavpack"
GST_PLUGINS_BAD="directsound directdraw osx_video quicktime vcd assrender amrwb apexsink bz2
			cdaudio celt cog dc1394 directfb dirac dts divx faac faad fbdev flite
			gsm jp2k kate ladspa lv2 libmms modplug mimic mpeg2enc mplex musepack
			musicbrainz mythtv nas neon ofa rsvg timidity wildmidi sdl sndfile
			soundtouch spc gme swfdec xvid dvb wininet acm vdpau schro zbar resindvd"
GST_PLUGINS_UGLY="a52dec amrnb amrwb cdio dvdread lame mad mpeg2dec sidplay twolame x264"

GST_PLUGINS_ALL="${GST_PLUGINS_BASE} ${GST_PLUGINS_GOOD} ${GST_PLUGINS_BAD} ${GST_PLUGINS_UGLY}"
#for plugin in ${GST_PLUGINS_ALL}; do
#	IUSE_GST_PLUGINS="${IUSE_GST_PLUGINS} gst_plugins_${plugin}"
#done

IUSE="${IUSE_GST_PLUGINS}"

#>=media-libs/gstreamer-1.0.1:1.0[introspection?]
#introspection?          ( >=dev-libs/gobject-introspection-0.9.12 )
#orc?                    ( >=dev-lang/orc-0.4.16 )

DEPEND="app-text/iso-codes
	>=dev-libs/glib-2.22:2
	dev-libs/libxml2:2
	>=sys-devel/gettext-0.11.5
	sys-libs/zlib
	virtual/pkgconfig
	gst_plugins_a52dec?	( >=media-libs/a52dec-0.7.3 )
	gst_plugins_alsa?	( >=media-libs/alsa-lib-0.9.1 )
	gst_plugins_cdparanoia?	( >=media-sound/cdparanoia-3.10.2-r3 )
	gst_plugins_dts?	( media-libs/libdca )
	gst_plugins_libdv?	( >=media-libs/libdv-0.100 )
	gst_plugins_dvb?	( virtual/os-headers )
	gst_plugins_dvdread?	( media-libs/libdvdread )
	gst_plugins_faad?	( media-libs/faad2 )
	gst_plugins_flac?	( >=media-libs/flac-1.1.4 )
	gst_plugins_gio?	( >=dev-libs/glib-2.16 )
	gst_plugins_gnomevfs?	( >=gnome-base/gnome-vfs-2 )
	gst_plugins_jack?	( >=media-sound/jack-audio-connection-kit-0.99.10 )
	gst_plugins_jpeg?	( virtual/jpeg )
	gst_plugins_lame?	( >=media-sound/lame-3.95 )"
RDEPEND="${DEPEND}"


src_prepare() {
	# gst doesnt handle optimisations well
	strip-flags
	replace-flags "-O3" "-O2"
	filter-flags "-fprefetch-loop-arrays" # see bug 22249

	gst_base_conf="--disable-oggtest \
		--disable-vorbistest \
		--disable-examples \
		--disable-freetypetest"

	gst_good_conf="--disable-aalibtest \
		--disable-esdtest \
		--disable-shout2test"

	gst_bad_conf="--disable-sdltest"
}

src_compile() {
	:
	exit
}
