# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Unity Desktop - merge this to pull in all Unity indicators"
HOMEPAGE="http://unity.ubuntu.com/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+battery bluetooth +datetime dispatcher +keyboard paste +printer sensors +session +sound weather"
RESTRICT="mirror"

DEPEND="unity-indicators/indicator-application
	unity-indicators/indicator-appmenu
	battery? ( unity-indicators/indicator-power[dispatcher?] )
	bluetooth? ( unity-indicators/indicator-bluetooth[dispatcher?] )
	datetime? ( unity-indicators/indicator-datetime[dispatcher?] )
	keyboard? ( unity-indicators/indicator-keyboard[dispatcher?] )
	paste? ( unity-extra/glipper )
	printer? ( unity-indicators/indicator-printers )
	sensors? ( unity-extra/indicator-psensor )
	session? ( unity-indicators/indicator-session[dispatcher?] )
	sound? ( unity-indicators/indicator-sound[dispatcher?] )
	weather? ( unity-extra/indicator-weather )"
RDEPEND="${DEPEND}"
