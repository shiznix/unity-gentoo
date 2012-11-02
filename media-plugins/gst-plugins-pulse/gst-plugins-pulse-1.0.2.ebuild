EAPI=3

inherit gst-plugins-good101

DESCRIPTION="GStreamer plugin for the PulseAudio sound server"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE=""

# >=0.9.20 is the latest suggested dep for some optional features/best behaviour not available before
RDEPEND=">=media-sound/pulseaudio-0.9.20
	>=media-libs/gst-plugins-base-${PV}:${SLOT}"
DEPEND="${RDEPEND}"
