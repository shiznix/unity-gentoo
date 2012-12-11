EAPI=4

DESCRIPTION="Unity Desktop - merge this to pull in all Unity packages"
HOMEPAGE="http://unity.ubuntu.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!unity-base/unity2d
	>=gnome-extra/nm-applet-99.0.9.4.1
	unity-base/ido
	unity-base/indicator-applet
	unity-base/indicator-application
	unity-base/indicator-appmenu
	unity-base/indicator-datetime
	unity-base/indicator-session
	unity-base/indicator-sound
	unity-base/ubuntuone-control-panel
	<unity-base/unity-6.0
	<=unity-base/unity-lens-applications-5.12.0
	<=unity-base/unity-lens-files-5.12.0
	<=unity-base/unity-lens-music-5.12.0
	<=unity-base/unity-lens-video-0.3.5
	unity-base/unity-scope-video-remote"
