# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

URELEASE="wily"
inherit eutils gnome2-utils python-single-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Monochrome icons for the Unity desktop (default icon theme)"
HOMEPAGE="https://launchpad.net/ubuntu-themes"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="!x11-themes/light-themes
	x11-themes/hicolor-icon-theme"
DEPEND="${RDEPEND}
	x11-misc/icon-naming-utils
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_configure() { :; }

src_compile() {
	emake
}

src_install() {
	## Install icons ##
	insinto /usr/share/icons
	doins -r LoginIcons ubuntu-mono-dark ubuntu-mono-light

	insinto /usr/share/icons/suru
	doins -r suru-icons/*

	## Install themes ##
	insinto /usr/share/themes
	doins -r Ambiance Radiance ubuntu-mobile

	## Remove broken symlinks ##
	find -L "${ED}" -type l -exec rm {} +
}
