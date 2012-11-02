EAPI=3

inherit gst-plugins-good101

DESCRIPTION="GStreamer plugin to demux and decode DV"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE=""

RDEPEND=">=media-libs/libdv-0.100
	>=media-libs/gst-plugins-base-${PV}:${SLOT}"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="libdv"
