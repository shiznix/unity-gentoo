# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="cosmic"
inherit autotools eutils ubuntu-versionator

UVER_PREFIX="+17.10.${PVR_MICRO}"

DESCRIPTION="Gnome panel indicator for the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-applet"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-2.1 LGPL-3 GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libindicator:3
	x11-libs/gtk+:3
	gnome-base/gnome-panel"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare

	# "Only <glib.h> can be included directly." #
	sed -e "s:glib/gtypes.h:glib.h:g" \
		-i src/tomboykeybinder.h
	eautoreconf
}
