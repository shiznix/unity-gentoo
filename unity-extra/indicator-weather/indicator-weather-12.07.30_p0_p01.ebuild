EAPI=4
PYTHON_DEPEND="2:2.7"
#SUPPORT_PYTHON_ABIS="1"	# See bug notes below #
RESTRICT_PYTHON_ABIS="3.*"

# <dev-python/python-distutils-extra-2.37 has a bug where it can't parse 'python2.7 setup.py build -b build-2.7 ...'
# 	as used by distutils.eclass for multi-python ABI installs
#  Error example:
#	File "/usr/lib64/python2.7/distutils/versionpredicate.py", line 160, in split_provision
#	  raise ValueError("illegal provides specification: %r" % value)

inherit distutils eutils gnome2-utils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/universe/i/${PN}"
URELEASE="quantal"
GNOME2_LA_PUNT="1"

DESCRIPTION="Weather indicator used by the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=dev-python/python-distutils-extra-2.37
	dev-python/pywapi
	dev-lang/vala:0.14[vapigen]
	dev-libs/libappindicator
	dev-libs/libdbusmenu[gtk]
	dev-libs/libindicate-qt"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r 2 .
	epatch "${FILESDIR}/lp821233.diff"
}

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
