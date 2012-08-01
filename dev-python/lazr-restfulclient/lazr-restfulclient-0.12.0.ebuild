EAPI=4
PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_PN="lazr.restfulclient"
UURL="http://archive.ubuntu.com/ubuntu/pool/main/l/${MY_PN}"
UVER="1ubuntu1"
URELEASE="precise"
MY_P="${MY_PN}_${PV}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Client for lazr.restful-based web services for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/python"

S="${WORKDIR}/lazr.restfulclient-${PV}"
