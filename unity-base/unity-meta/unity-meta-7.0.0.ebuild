EAPI=4

DESCRIPTION="Unity Desktop - merge this to pull in all Unity packages"
HOMEPAGE="http://unity.ubuntu.com/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+chat +webapps"

DEPEND="app-backup/deja-dup[nautilus]
	gnome-base/nautilus
	gnome-extra/activity-log-manager
	gnome-extra/nm-applet
	net-libs/telepathy-indicator
	unity-base/gnome-control-center-unity
	unity-base/ido
	unity-base/ido-gtk2
	unity-base/ubuntuone-control-panel
	unity-base/unity
	unity-indicators/unity-indicators-meta
	unity-lenses/unity-lens-meta
	x11-themes/ubuntu-wallpapers
	chat? ( net-im/empathy )
	webapps? ( unity-base/webapps
			unity-extra/unsettings
			x11-misc/webaccounts-browser-extension
			x11-misc/webapps-greasemonkey )"
RDEPEND="${DEPEND}"
