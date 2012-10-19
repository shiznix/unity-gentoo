EAPI=3

GCONF_DEBUG=no

inherit gnome2 gst-plugins-good101 gst-plugins101

DESCRIPTION="GStreamer plugin for wrapping GConf audio/video settings"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE=""

RDEPEND=">=gnome-base/gconf-2
	>=media-libs/gst-plugins-base-${PV}:${SLOT}"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="gconf gconftool"
