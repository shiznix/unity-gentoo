EAPI=4

inherit base eutils python

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
UVER="0ubuntu1"
URELEASE="precise"
MY_P="${P/evemu-/evemu_}"

DESCRIPTION="Event Emulation for the uTouch Stack"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!!unity-base/evemu
	dev-lang/python:2.7"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}
