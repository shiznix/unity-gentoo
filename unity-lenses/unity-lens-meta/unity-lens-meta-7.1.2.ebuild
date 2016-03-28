# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Unity Desktop - merge this to pull in all Unity lenses"
HOMEPAGE="http://unity.ubuntu.com/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+applications +files +music +photos +video"
RESTRICT="mirror"

DEPEND="applications? ( unity-lenses/unity-lens-applications )
	files? ( unity-lenses/unity-lens-files )
	music? ( unity-lenses/unity-lens-music )
	photos? ( unity-lenses/unity-lens-photos )
	video? ( unity-lenses/unity-lens-video )
	unity-scopes/smart-scopes
	unity-scopes/unity-scope-home"
RDEPEND="${DEPEND}"
