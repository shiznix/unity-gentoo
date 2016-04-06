# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit ubuntu-versionator

DESCRIPTION="Unity Desktop - merge this to pull in all Unity packages"
HOMEPAGE="http://unity.ubuntu.com/"

URELEASE="xenial"

LICENSE="metapackage"
SLOT="0/${URELEASE}"
KEYWORDS="~amd64 ~x86"
IUSE="accessibility +chat gnome gnome-extras +xdm +webapps"
RESTRICT="mirror"

DEPEND="app-backup/deja-dup[nautilus]
	gnome-base/gnome-core-libs
	gnome-base/nautilus
	gnome-extra/activity-log-manager
	gnome-extra/nm-applet
	net-libs/telepathy-indicator
	unity-base/hud
	unity-base/unity
	unity-base/unity-build-env
	unity-base/unity-control-center
	unity-extra/unity-tweak-tool
	unity-indicators/unity-indicators-meta
	unity-lenses/unity-lens-meta
	x11-misc/notify-osd
	x11-themes/ubuntu-wallpapers
	accessibility? (
		app-accessibility/at-spi2-atk
		app-accessibility/at-spi2-core
		app-accessibility/caribou
		app-accessibility/orca
		gnome-extra/mousetweaks )
	chat? ( net-im/empathy )
	gnome? ( gnome-base/gnome-core-apps )
	gnome-extras? ( gnome-base/gnome-extra-apps )
	webapps? ( unity-base/webapps
			x11-misc/webaccounts-browser-extension
			x11-misc/webapps-greasemonkey )
	xdm? ( || ( unity-extra/unity-greeter gnome-base/gdm ) )"
