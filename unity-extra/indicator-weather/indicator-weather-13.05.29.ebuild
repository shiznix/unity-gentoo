# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

# <dev-python/python-distutils-extra-2.37 has a bug where it can't parse 'python2.7 setup.py build -b build-2.7 ...'
# 	as used by distutils.eclass for multi-python ABI installs
#  Error example:
#	File "/usr/lib64/python2.7/distutils/versionpredicate.py", line 160, in split_provision
#	  raise ValueError("illegal provides specification: %r" % value)

inherit distutils-r1 eutils gnome2-utils ubuntu-versionator

#URELEASE="saucy"	# Was dropped from Raring for being buggy, uncomment when it rejoins to become part of Saucy #
MY_PN="weather-indicator"

DESCRIPTION="Weather indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-weather"
SRC_URI="https://launchpad.net/weather-indicator/2.0/${PV}/+download/${MY_PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror nodoc"

DEPEND="dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate-qt
	>=dev-python/python-distutils-extra-2.37
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/pywapi-0.3.3[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_PN}_${PV}"

src_prepare() {
	sed -e 's:share/common-licenses:portage/licenses:g' \
		-i bin/indicator-weather
}

src_compile() {
	# Unable to reproduce but can still happen on some systems #
	#  Maybe some imported python lib from python-distutils-extra causing issue ? #
	addpredict /root/.cache/dconf/user	# FIXME
	addpredict /root/.config/dconf/user	# FIXME

	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install

	dodir /usr/share/doc/${PN}
	docompress -x /usr/share/doc/${PN}
	cp AUTHORS "${ED}usr/share/doc/${PN}/"

	# Delete some files that are only useful on Ubuntu
	rm -rf "${D}"etc/apport

	python_fix_shebang "${ED}"
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
}
