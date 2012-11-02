EAPI=3

inherit gst-plugins-good101

IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-${PV}:${SLOT}
	>=media-sound/wavpack-4.40"
DEPEND="${RDEPEND}"
