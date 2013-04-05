EAPI=4
GNOME2_LA_PUNT="yes"

PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils ubuntu-versionator

MY_PN="lazr.restfulclient"
UURL="http://archive.ubuntu.com/ubuntu/pool/main/l/${MY_PN}"
UVER="1"
URELEASE="raring"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Client for lazr.restful-based web services for the Unity desktop"
HOMEPAGE="https://launchpad.net/lazr.restfulclient"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-python/httplib2
	dev-python/oauth
	dev-python/simplejson
	net-zope/zope-interface"

S="${WORKDIR}/lazr.restfulclient-${PV}"
