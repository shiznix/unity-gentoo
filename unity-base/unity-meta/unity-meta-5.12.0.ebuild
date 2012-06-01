EAPI=4

DESCRIPTION="Unity Desktop - merge this to pull in all Unity packages"
HOMEPAGE="http://unity.ubuntu.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="unity-base/ido
	unity-base/indicator-applet
	unity-base/indicator-application
	unity-base/indicator-appmenu
	unity-base/indicator-datetime
	unity-base/indicator-power
	unity-base/unity
	unity-base/unity-lens-files"

pkg_postinst() {
	einfo "It is recommended to enable the 'ayatana' USE flag"
	einfo "for portage packages that can use the Unity"
	einfo "libindicate or libappindicator notification plugins"
}
