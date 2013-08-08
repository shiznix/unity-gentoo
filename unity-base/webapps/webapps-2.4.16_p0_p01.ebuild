# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils gnome2-utils python ubuntu-versionator

MY_PN="webapps-applications"
URELEASE="saucy"
UVER_PREFIX="+13.10.20130715"
UURL="mirror://ubuntu/pool/main/w/${MY_PN}"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="WebApps: Initial set of Apps for the Unity desktop"
HOMEPAGE="https://launchpad.net/webapps-applications"
SRC_URI="${UURL}/${MY_PN}_${PV}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="ubuntuonemusic-old-store"
RESTRICT="mirror"

DEPEND=">=dev-libs/glib-2.32.3
	dev-libs/json-glib
	dev-libs/libindicate[gtk,introspection]
	dev-libs/libunity
	dev-libs/libunity-webapps
	dev-python/polib
	x11-libs/gtk+:3
	x11-themes/unity-asset-pool"

src_prepare() {
	python_convert_shebangs -r 2 .

	# Allow the use of the more featureful old music store as presented in the old Quantal version of the rhythmbox-ubuntuone plugin #
	use ubuntuonemusic-old-store && \
		sed -e 's:one.ubuntu.com/music-store/:one.ubuntu.com/music/store-no-token:' \
			-i default-apps/UbuntuOneMusiconeubuntucom.desktop.in
	eautoreconf
}

src_configure() {
	econf \
		--enable-applications \
		--enable-default-applications
}

src_install() {
	emake DESTDIR="${D}" install

	mv scripts/install-default-webapps-in-launcher.py scripts/install-default-webapps-in-launcher
	dobin scripts/install-default-webapps-in-launcher

	# Move userscripts into their proper directory names #
	for webapp in `find "${D}usr/share/unity-webapps/userscripts" -name "*.user.js" | awk -F.user.js '{print $1}' | awk -F/ ' { print ( $(NF-1) ) }'`; do
		mv "${D}usr/share/unity-webapps/userscripts/${webapp}" \
			"${D}usr/share/unity-webapps/userscripts/unity-webapps-`echo ${webapp} | tr '[A-Z]' '[a-z]'`"
	done
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
