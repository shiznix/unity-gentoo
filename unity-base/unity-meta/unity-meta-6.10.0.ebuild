EAPI=4

DESCRIPTION="Unity Desktop - merge this to pull in all Unity packages"
HOMEPAGE="http://unity.ubuntu.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!unity-base/unity2d
	>=gnome-base/nautilus-99.3.6.3
	gnome-extra/activity-log-manager
	>=gnome-extra/nm-applet-99.0.9.4.1
	>=net-im/empathy-99.3.6.2
	net-libs/telepathy-indicator
	unity-base/gnome-control-center-unity
	unity-base/ido
	unity-base/ido-gtk2
	unity-base/indicator-applet
	unity-base/indicator-application
	unity-base/indicator-appmenu
	unity-base/indicator-datetime
	unity-base/indicator-session
	unity-base/indicator-sound
	unity-base/ubuntuone-control-panel
	=unity-base/unity-${PV}
	unity-base/unity-lens-applications
	unity-base/unity-lens-files
	unity-base/unity-lens-music
	unity-base/unity-lens-photos
	unity-base/unity-lens-video
	unity-base/unity-scope-video-remote"
