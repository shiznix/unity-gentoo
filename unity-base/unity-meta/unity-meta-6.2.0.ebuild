EAPI=4

DESCRIPTION="Unity Desktop - merge this to pull in all Unity packages"
HOMEPAGE="http://unity.ubuntu.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=gnome-extra/nm-applet-99.0.9.4.1
	unity-base/ido
	unity-base/indicator-applet
	unity-base/indicator-application
	unity-base/indicator-appmenu
	unity-base/indicator-datetime
	unity-base/indicator-session
	unity-base/indicator-sound
	unity-base/ubuntuone-control-panel
	unity-base/unity
	unity-base/unity2d
	unity-base/unity-lens-files
	unity-base/unity-lens-music
	unity-base/unity-lens-video
	unity-base/unity-scope-video-remote
	x11-themes/ubuntu-mono"
