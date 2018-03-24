# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

# <dev-python/python-distutils-extra-2.37 has a bug where it can't parse 'python2.7 setup.py build -b build-2.7 ...'
# 	as used by distutils.eclass for multi-python ABI installs
#  Error example:
#	File "/usr/lib64/python2.7/distutils/versionpredicate.py", line 160, in split_provision
#	  raise ValueError("illegal provides specification: %r" % value)

inherit distutils-r1 eutils gnome2-utils ubuntu-versionator

#URELEASE="wily"	# Was dropped from Raring for being buggy, uncomment when it rejoins #
UVER=

DESCRIPTION="Weather indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/weather-indicator"
SRC_URI="https://launchpad.net/weather-indicator/2.0/${PV}/+download/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-libs/libindicate-qt
	>=dev-python/python-distutils-extra-2.37
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/pywapi-0.3.7[${PYTHON_USEDEP}]
	x11-themes/adwaita-icon-theme"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	sed -e 's:share/common-licenses:portage/licenses:g' \
		-i bin/indicator-weather

	# Make desktop file compliant #
	sed -e 's:\(False\):\L\1:g' \
		-i indicator-weather.desktop.in
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install

	dodir /usr/share/doc/${PN}
	docompress -x /usr/share/doc/${PN}
	cp AUTHORS "${ED}usr/share/doc/${PN}/"

	# Delete some files that are only useful on Ubuntu
	rm -rf "${D}"etc/apport

	python_fix_shebang "${ED}"

	dosym /usr/share/icons/gnome/22x22/status/weather-few-clouds.png \
		/usr/share/icons/gnome/22x22/status/weather-clouds.png
}

pkg_preinst() {
	gnome2_schemas_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg-icon-resource install --theme hicolor --novendor --size 22 \
		"${EROOT}/usr/share/indicator-weather/media/icon.png" weather-indicator \
			|| die "icon resource installation failed"
	xdg-icon-resource install --theme hicolor --novendor --size 22 \
		"${EROOT}/usr/share/indicator-weather/media/icon_unknown_condition.png" weather-indicator-unknown \
			|| die "icon resource installation failed"
	xdg-icon-resource install --theme hicolor --novendor --size 22 \
		"${EROOT}/usr/share/indicator-weather/media/icon_connection_error.png" weather-indicator-error \
			|| die "icon resource installation failed"
	xdg-icon-resource forceupdate

	gnome2_schemas_update
	gnome2_icon_cache_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
