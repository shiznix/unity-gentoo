EAPI=3

inherit gst-plugins-bad101

DESCRIPTION="GStreamer plugin for MPEG/DVD/SVCD/VCD video/audio multiplexing"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE=""

RDEPEND=">=media-video/mjpegtools-1.9.0
	>=media-libs/gst-plugins-base-${PV}:${SLOT}"
DEPEND="${RDEPEND}"
