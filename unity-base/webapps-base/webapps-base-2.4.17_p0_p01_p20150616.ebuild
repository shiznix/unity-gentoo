# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

URELEASE="wily"
inherit autotools gnome2-utils python-r1 ubuntu-versionator

MY_PN="webapps-applications"
UURL="mirror://unity/pool/main/w/${MY_PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="WebApps: Initial set of Apps for the Unity desktop"
HOMEPAGE="https://launchpad.net/webapps-applications"
SRC_URI="${UURL}/${MY_PN}_${PV}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libindicate[gtk,introspection]
	dev-libs/libunity
	dev-libs/libunity-webapps
	dev-python/polib[${PYTHON_USEDEP}]
	x11-libs/gtk+:3
	x11-themes/unity-asset-pool
	${PYTHON_DEPS}"

S="${WORKDIR}/${MY_PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure() {
	econf
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${ED}" install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
}
