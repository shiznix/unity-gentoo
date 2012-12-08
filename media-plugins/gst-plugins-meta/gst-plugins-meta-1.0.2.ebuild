EAPI=3

DESCRIPTION="Meta ebuild to pull in gst plugins for apps"
HOMEPAGE="http://www.gentoo.org"

LICENSE="GPL-2"
SLOT="1.0"
KEYWORDS=""
#KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="aac a52 alsa dts dv dvb dvd libav flac http lame libvisual mms mp3 mpeg musepack ogg oss pulseaudio taglib theora v4l vcd vorbis vpx wavpack X xv"

RDEPEND=">=media-libs/gstreamer-${PV}:${SLOT}
	>=media-libs/gst-plugins-base-${PV}:${SLOT}
	>=media-libs/gst-plugins-good-${PV}:${SLOT}
	aac? ( >=media-plugins/gst-plugins-faad-${PV}:${SLOT} )
	alsa? ( >=media-libs/gst-plugins-base-${PV}:${SLOT}[alsa] )
	dts? ( >=media-plugins/gst-plugins-dts-${PV}:${SLOT} )
	dv? ( >=media-plugins/gst-plugins-dv-${PV}:${SLOT} )
	dvb? (
		>=media-plugins/gst-plugins-dvb-${PV}:${SLOT}
		>=media-libs/gst-plugins-bad-${PV}:${SLOT} )
	dvd? (
		>=media-libs/gst-plugins-ugly-${PV}:${SLOT}
		>=media-plugins/gst-plugins-a52dec-${PV}:${SLOT}
		>=media-plugins/gst-plugins-dvdread-${PV}:${SLOT}
		>=media-plugins/gst-plugins-mpeg2dec-${PV}:${SLOT}
		>=media-plugins/gst-plugins-resindvd-${PV}:${SLOT} )
	flac? ( >=media-plugins/gst-plugins-flac-${PV}:${SLOT} )
	http? ( >=media-plugins/gst-plugins-soup-${PV}:${SLOT} )
	lame? ( >=media-plugins/gst-plugins-lame-${PV}:${SLOT} )
	libav? ( >=media-plugins/gst-plugins-libav-${PV}:${SLOT} )
	libvisual? ( >=media-plugins/gst-plugins-libvisual-${PV}:${SLOT} )
	mms? ( >=media-plugins/gst-plugins-libmms-${PV}:${SLOT} )
	mp3? ( >=media-libs/gst-plugins-ugly-${PV}:${SLOT}
		>=media-plugins/gst-plugins-mad-${PV}:${SLOT} )
	mpeg? ( >=media-plugins/gst-plugins-mpeg2dec-${PV}:${SLOT} )
	musepack? ( >=media-plugins/gst-plugins-musepack-${PV}:${SLOT} )
	ogg? ( >=media-libs/gst-plugins-base-${PV}:${SLOT}[ogg] )
	oss? ( >=media-plugins/gst-plugins-oss-${PV}:${SLOT} )
	pulseaudio? ( >=media-plugins/gst-plugins-pulse-${PV}:${SLOT} )
	theora? ( >=media-libs/gst-plugins-base-${PV}:${SLOT}[ogg,theora] )
	taglib? ( >=media-plugins/gst-plugins-taglib-${PV}:${SLOT} )
	v4l? ( >=media-plugins/gst-plugins-v4l2-${PV}:${SLOT} )
	vcd? (	>=media-plugins/gst-plugins-mplex-${PV}:${SLOT}
		>=media-plugins/gst-plugins-mpeg2dec-${PV}:${SLOT} )
	vorbis? ( >=media-libs/gst-plugins-base-${PV}:${SLOT}[ogg,vorbis] )
	vpx? ( >=media-plugins/gst-plugins-vpx-${PV}:${SLOT} )
	wavpack? ( >=media-plugins/gst-plugins-wavpack-${PV}:${SLOT} )
	X? ( >=media-libs/gst-plugins-base-${PV}:${SLOT}[X] )
	xv? ( >=media-libs/gst-plugins-base-${PV}:${SLOT}[X] )"

# Usage note:
# The idea is that apps depend on this for optional gstreamer plugins.  Then,
# when USE flags change, no app gets rebuilt, and all apps that can make use of
# the new plugin automatically do.

# When adding deps here, make sure the keywords on the gst-plugin are valid.
