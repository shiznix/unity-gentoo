EAPI=3

# Used for runtime detection of MMX/3dNow/MMXEXT and telling liba52dec
GST_ORC=yes

inherit gst-plugins-ugly101

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE=""

RDEPEND=">=media-libs/a52dec-0.7.3
	>=media-libs/gst-plugins-base-${PV}:${SLOT}
	>=media-libs/gstreamer-${PV}:${SLOT}"
DEPEND="${RDEPEND}"
