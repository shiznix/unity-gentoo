EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/n/${PN}"
UVER="0ubuntu1"
URELEASE="precise"
MY_P="${P/-/_}"

DESCRIPTION="Visual rendering toolkit for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"

SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-i18n/ibus
	unity-base/utouch-geis"

PATCHES=( "${WORKDIR}/${MY_P}-${UVER}.diff" )
