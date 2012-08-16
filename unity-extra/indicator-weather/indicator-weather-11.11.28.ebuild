EAPI=4
PYTHON_DEPEND="2:2.7"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils gnome2-utils

UURL="http://archive.ubuntu.com/ubuntu/pool/universe/i/${PN}"
UVER="0ubuntu1"
URELEASE="precise"
MY_P="${P/weather-/weather_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Weather indicator used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/python-distutils-extra
	dev-python/pywapi
	dev-lang/vala:0.14[vapigen]
	dev-libs/libappindicator
	>=dev-libs/libdbusmenu-0.6.1[gtk]
	dev-libs/libindicate-qt"

S="${WORKDIR}/cloudy"

src_install() {
	distutils_src_install

	# Delete some files that are only useful on Ubuntu
	rm -rf "${D}"etc/apport
}

pkg_preinst() {
                gnome2_schemas_savelist
}

pkg_postinst() {
                gnome2_schemas_update
}

pkg_postrm() {
                gnome2_schemas_update
}
