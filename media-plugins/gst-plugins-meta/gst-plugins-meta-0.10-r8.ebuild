EAPI=4

DESCRIPTION="Meta ebuild to pull in gst plugins for apps"
HOMEPAGE="http://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0.10"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="aac a52 alsa dts dv dvb dvd ffmpeg flac http lame libvisual mms mp3 mpeg musepack ogg oss pulseaudio taglib theora v4l vcd vorbis vpx wavpack X xv"

BASE_VER="0.10.36"
GOOD_VER="0.10.31"
BAD_VER="0.10.23"
UGLY_VER="0.10.19"

RDEPEND=">=media-libs/gstreamer-${BASE_VER}:0.10
	>=media-libs/gst-plugins-base-${BASE_VER}:0.10
	>=media-libs/gst-plugins-good-${GOOD_VER}:0.10
	a52? ( >=media-plugins/gst-plugins-a52dec-${UGLY_VER}:0.10 )
	aac? ( >=media-plugins/gst-plugins-faad-${BAD_VER}:0.10 )
	alsa? ( >=media-plugins/gst-plugins-alsa-${BASE_VER}:0.10 )
	dts? ( >=media-plugins/gst-plugins-dts-${BAD_VER}:0.10 )
	dv? ( >=media-plugins/gst-plugins-dv-${GOOD_VER}:0.10 )
	dvb? (
		>=media-libs/gst-plugins-bad-${BAD_VER}:0.10 )
		>=media-plugins/gst-plugins-dvb-${BAD_VER}:0.10
	dvd? (
		>=media-libs/gst-plugins-ugly-${UGLY_VER}:0.10
		>=media-plugins/gst-plugins-a52dec-${UGLY_VER}:0.10
		>=media-plugins/gst-plugins-dvdread-${UGLY_VER}:0.10
		>=media-plugins/gst-plugins-mpeg2dec-${UGLY_VER}:0.10
		>=media-plugins/gst-plugins-resindvd-${BAD_VER}:0.10 )
	ffmpeg? ( >=media-plugins/gst-plugins-ffmpeg-0.10.13:0.10 )
	flac? ( >=media-plugins/gst-plugins-flac-${GOOD_VER}:0.10 )
	http? ( >=media-plugins/gst-plugins-soup-${GOOD_VER}:0.10 )
	lame? ( >=media-plugins/gst-plugins-lame-${UGLY_VER}:0.10 )
	libvisual? ( >=media-plugins/gst-plugins-libvisual-0.10.36:0.10 )
	mms? ( >=media-plugins/gst-plugins-libmms-${BAD_VER}:0.10 )
	mp3? ( >=media-libs/gst-plugins-ugly-${UGLY_VER}:0.10
		>=media-plugins/gst-plugins-mad-${UGLY_VER}:0.10 )
	mpeg? ( >=media-plugins/gst-plugins-mpeg2dec-${UGLY_VER}:0.10 )
	musepack? ( >=media-plugins/gst-plugins-musepack-${BAD_VER}:0.10 )
	ogg? ( >=media-plugins/gst-plugins-ogg-${BASE_VER}:0.10 )
	oss? ( >=media-plugins/gst-plugins-oss-${GOOD_VER}:0.10 )
	pulseaudio? ( >=media-plugins/gst-plugins-pulse-${GOOD_VER}:0.10 )
	theora? ( >=media-plugins/gst-plugins-ogg-${BASE_VER}:0.10
		>=media-plugins/gst-plugins-theora-${BASE_VER}:0.10 )
	taglib? ( >=media-plugins/gst-plugins-taglib-${GOOD_VER}:0.10 )
	v4l? ( >=media-plugins/gst-plugins-v4l2-${GOOD_VER}:0.10 )
	vcd? (	>=media-plugins/gst-plugins-mplex-${BAD_VER}:0.10
		>=media-plugins/gst-plugins-mpeg2dec-${UGLY_VER}:0.10 )
	vorbis? ( >=media-plugins/gst-plugins-ogg-${BASE_VER}:0.10
		>=media-plugins/gst-plugins-vorbis-${BASE_VER}:0.10 )
	vpx? ( >=media-plugins/gst-plugins-vp8-${BAD_VER}:0.10 )
	wavpack? ( >=media-plugins/gst-plugins-wavpack-${GOOD_VER}:0.10 )
	X? ( >=media-plugins/gst-plugins-x-${BASE_VER}:0.10 )
	xv? ( >=media-plugins/gst-plugins-xvideo-${BASE_VER}:0.10 )"

# Usage note:
# The idea is that apps depend on this for optional gstreamer plugins.  Then,
# when USE flags change, no app gets rebuilt, and all apps that can make use of
# the new plugin automatically do.

# When adding deps here, make sure the keywords on the gst-plugin are valid.
