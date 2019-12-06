# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Unity Desktop - merge this to pull in all Unity lenses"
HOMEPAGE="http://unity.ubuntu.com/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+files +music +photos +plugins +video"
RESTRICT="mirror"

DEPEND="unity-lenses/unity-lens-applications
	unity-scopes/unity-scope-home

	files? ( unity-lenses/unity-lens-files )
	music? ( unity-lenses/unity-lens-music )
	photos? ( unity-lenses/unity-lens-photos )
	plugins? ( unity-scopes/smart-scopes )
	video? ( unity-lenses/unity-lens-video )"
RDEPEND="${DEPEND}"
PDEPEND="unity-base/unity-settings[files=,music=,photos=,video=]"
