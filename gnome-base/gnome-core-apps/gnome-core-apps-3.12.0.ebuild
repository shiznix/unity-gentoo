# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="Sub-meta package for the core applications integrated with GNOME 3"
HOMEPAGE="http://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+bluetooth +cdr cups"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~amd64 ~x86"

# Note to developers:
# This is a wrapper for the core apps tightly integrated with GNOME 3
# gtk-engines:2 is still around because it's needed for gtk2 apps
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-${PV}
	>=gnome-base/gnome-menus-3.10:3
	>=gnome-base/gnome-settings-daemon-${PV}[cups?]

	>=app-crypt/gcr-${PV}
	>=gnome-base/nautilus-3.10
	>=gnome-base/gnome-keyring-${PV}
	>=gnome-extra/evolution-data-server-${PV}

	>=app-crypt/seahorse-${PV}
	>=app-editors/gedit-${PV}
	>=app-text/evince-${PV}
	>=gnome-extra/gnome-contacts-${PV}
	>=media-gfx/eog-${PV}
	>=media-video/totem-${PV}
	>=net-im/empathy-3.8
	>=x11-terms/gnome-terminal-${PV}

	>=gnome-extra/gnome-user-docs-${PV}
	>=gnome-extra/yelp-${PV}

	>=x11-themes/gtk-engines-2.20.2:2
	>=x11-themes/gnome-icon-theme-${PV}
	>=x11-themes/gnome-icon-theme-symbolic-${PV}
	>=x11-themes/gnome-themes-standard-${PV}

	bluetooth? ( >=net-wireless/gnome-bluetooth-${PV} )
	cdr? ( >=app-cdr/brasero-${PV} )

	!gnome-base/gnome-applets
"
DEPEND=""

S="${WORKDIR}"
