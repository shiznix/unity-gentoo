EAPI=4

DESCRIPTION="Unity Desktop - merge this to pull in all Unity packages"
HOMEPAGE="http://unity.ubuntu.com/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+battery +bluetooth +datetime +session +sound +sync"

DEPEND="unity-indicators/indicator-applet
	unity-indicators/indicator-application
	unity-indicators/indicator-appmenu
	battery? ( unity-indicators/indicator-power )
	bluetooth? ( unity-indicators/indicator-bluetooth )
	datetime? ( unity-indicators/indicator-datetime )
	session? ( unity-indicators/indicator-session )
	sound? ( unity-indicators/indicator-sound )
	sync? ( unity-indicators/indicator-sync )"
RDEPEND="${DEPEND}"
