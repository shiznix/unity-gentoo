EAPI=4

DESCRIPTION="Unity Desktop - merge this to pull in all Unity packages"
HOMEPAGE="http://unity.ubuntu.com/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+applications +files +music +photos +video"

DEPEND="applications? ( unity-lenses/unity-lens-applications )
	files? ( unity-lenses/unity-lens-files )
	music? ( unity-lenses/unity-lens-music )
	photos? ( unity-lenses/unity-lens-photos )
	video? ( unity-lenses/unity-lens-video
			unity-lenses/unity-scope-video-remote )"
RDEPEND="${DEPEND}"
