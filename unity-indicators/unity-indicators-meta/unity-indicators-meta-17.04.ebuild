# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Unity Desktop - merge this to pull in all Unity indicators"
HOMEPAGE="http://unity.ubuntu.com/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+battery bluetooth +datetime +keyboard paste +printer sensors +session +sound weather"
RESTRICT="mirror"

DEPEND="unity-indicators/indicator-application
	unity-indicators/indicator-appmenu
	battery? ( unity-indicators/indicator-power )
	bluetooth? ( unity-indicators/indicator-bluetooth )
	datetime? ( unity-indicators/indicator-datetime )
	keyboard? ( unity-indicators/indicator-keyboard )
	paste? ( unity-extra/glipper )
	printer? ( unity-indicators/indicator-printers )
	sensors? ( unity-extra/indicator-psensor )
	session? ( unity-indicators/indicator-session )
	sound? ( unity-indicators/indicator-sound )
	weather? ( unity-extra/indicator-weather )"
RDEPEND="${DEPEND}"
