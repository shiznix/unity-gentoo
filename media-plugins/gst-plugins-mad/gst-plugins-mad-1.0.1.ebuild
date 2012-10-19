EAPI=3

inherit gst-plugins-ugly101

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-${PV}:${SLOT}
	>=media-libs/gstreamer-${PV}:${SLOT}
	>=media-libs/libmad-0.15.1b
	>=media-libs/gst-plugins-good-${PV}:${SLOT}
	>=media-libs/libid3tag-0.15" # adds optional id3 tag support, but id3demux in -good should
	# be getting used in all cases for much more comprehensive ID3 tag support.
	# FIXME: Kill libid3tag dep once it's made not automagic
DEPEND="${RDEPEND}"
