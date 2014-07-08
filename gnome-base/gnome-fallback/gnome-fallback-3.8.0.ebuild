# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

UVER=
URELEASE="trusty"

DESCRIPTION="Sub-meta package for GNOME 3 fallback mode"
HOMEPAGE="https://wiki.gnome.org/GnomeFlashback"
LICENSE="metapackage"
SLOT="3.0"
IUSE="cups"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# Note to developers:
# This is a wrapper for the GNOME 3 fallback apps list
RDEPEND=">=gnome-base/gnome-core-libs-${PV}[cups?]
	gnome-base/gnome-panel
	>=gnome-extra/polkit-gnome-0.105
	x11-misc/notify-osd
	>=x11-wm/metacity-2.34.13"
DEPEND=""

S="${WORKDIR}"
