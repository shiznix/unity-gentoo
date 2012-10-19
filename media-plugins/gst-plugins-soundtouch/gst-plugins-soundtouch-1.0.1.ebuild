EAPI=3

inherit gst-plugins-bad101

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE=""
DESCRIPTION="GStreamer elements for beats-per-minute detection and pitch controlling"

RDEPEND=">=media-libs/libsoundtouch-1.4
	>=media-libs/gst-plugins-base-${PV}:${SLOT}"
DEPEND="${RDEPEND}"
