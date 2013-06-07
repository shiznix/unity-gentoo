# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Unity Desktop - merge this to pull in all Unity packages"
HOMEPAGE="http://unity.ubuntu.com/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+applications cooking +files friends +music +photos radio +video"
RESTRICT="mirror"

DEPEND="applications? ( unity-lenses/unity-lens-applications )
	cooking? ( unity-extra/unity-lens-cooking )
	files? ( unity-lenses/unity-lens-files )
	friends? ( unity-lenses/unity-lens-friends )
	music? ( unity-lenses/unity-lens-music )
	photos? ( unity-lenses/unity-lens-photos )
	radio? ( unity-extra/unity-lens-radios )
	video? ( unity-lenses/unity-lens-video )"
RDEPEND="${DEPEND}"
