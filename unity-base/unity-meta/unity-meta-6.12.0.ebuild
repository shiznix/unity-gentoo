EAPI=4

DESCRIPTION="Unity Desktop - merge this to pull in all Unity packages"
HOMEPAGE="http://unity.ubuntu.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="chat webapps"

DEPEND="!unity-base/unity2d
	app-backup/deja-dup[nautilus]
	gnome-base/nautilus
	gnome-extra/activity-log-manager
	gnome-extra/nm-applet
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
	unity-base/unity
	unity-base/unity-lens-applications
	unity-base/unity-lens-files
	unity-base/unity-lens-music
	unity-base/unity-lens-photos
	unity-base/unity-lens-video
	unity-base/unity-scope-video-remote
	webapps? ( unity-base/webapps
			unity-extra/unsettings
			x11-misc/webaccounts-browser-extension
			x11-misc/webapps-greasemonkey )
	chat? ( net-im/empathy )"
