# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Unity Desktop - merge this to pull in all Unity indicators"
HOMEPAGE="http://unity.ubuntu.com/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+battery bluetooth +cups +datetime +keyboard paste sensors +session +sound weather"
RESTRICT="mirror"

RDEPEND="unity-indicators/indicator-application
	unity-indicators/indicator-appmenu
	battery? ( unity-indicators/indicator-power )
	bluetooth? ( unity-indicators/indicator-bluetooth )
	cups? ( unity-indicators/indicator-printers )
	datetime? ( unity-indicators/indicator-datetime )
	keyboard? ( unity-indicators/indicator-keyboard )
	paste? ( x11-misc/copyq )
	sensors? ( unity-extra/indicator-psensor )
	session? ( unity-indicators/indicator-session )
	sound? ( unity-indicators/indicator-sound )
	weather? ( unity-extra/meteo-qt )"
