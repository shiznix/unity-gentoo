EAPI=4

inherit gst-plugins-bad101

DESCRIPTION="GStreamer plugin for MPEG-1/2 video encoding"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="+orc"

RDEPEND="media-libs/libdca
	>=media-libs/gstreamer-${PV}:${SLOT}
	>=media-libs/gst-plugins-base-${PV}:${SLOT}
	orc? ( >=dev-lang/orc-0.4.11 )"
DEPEND="${RDEPEND}"

src_configure() {
	gst-plugins-bad101_src_configure $(use_enable orc)
}
