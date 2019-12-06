# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit ubuntu-versionator

DESCRIPTION="Unity Desktop - merge this to pull in all Unity packages"
HOMEPAGE="http://unity.ubuntu.com/"

URELEASE="disco"

LICENSE="metapackage"
SLOT="0/${URELEASE}"
KEYWORDS="~amd64 ~x86"
IUSE="+accessibility +apps chat extras +fonts +games +utils +xdm"
RESTRICT="mirror"

GVER="3.32*"


DEPEND="unity-base/unity-build-env
	unity-extra/ehooks"

RDEPEND="gnome-base/gnome-core-libs
	gnome-base/nautilus
	gnome-extra/activity-log-manager
	gnome-extra/nm-applet
	media-fonts/dejavu
	media-fonts/ubuntu-font-family
	unity-base/unity
	unity-base/unity-control-center
	unity-base/unity-language-pack
	unity-indicators/unity-indicators-meta
	unity-lenses/unity-lens-meta
	x11-misc/gtk3-nocsd
	x11-misc/notify-osd
	x11-themes/ubuntu-wallpapers

	accessibility? (
		app-accessibility/at-spi2-atk
		app-accessibility/at-spi2-core
		app-accessibility/onboard
		app-accessibility/orca )
	apps? (
		app-office/libreoffice
		|| ( mail-client/thunderbird =mail-client/evolution-${GVER} )
		media-gfx/shotwell
		media-sound/rhythmbox
		=media-video/totem-${GVER}
		|| ( www-client/firefox www-client/chromium ) )
	chat? ( || (
		( net-im/pidgin x11-plugins/pidgin-libnotify )
		( net-im/empathy net-libs/telepathy-indicator ) ) )
	extras? (
		app-cdr/brasero
		=gnome-base/dconf-editor-3.30*
		gnome-extra/gnome-search-tool
		sys-block/gparted
		unity-extra/unity-tweak-tool )
	fonts? (
		media-fonts/dejavu
		media-fonts/droid
		media-fonts/font-bitstream-type1
		media-fonts/freefont
		media-fonts/kacst-fonts
		media-fonts/khmer
		media-fonts/liberation-fonts
		media-fonts/lklug
		media-fonts/lohit-assamese
		media-fonts/lohit-bengali
		media-fonts/lohit-devanagari
		media-fonts/lohit-gujarati
		media-fonts/lohit-gurmukhi
		media-fonts/lohit-kannada
		media-fonts/lohit-malayalam
		media-fonts/lohit-odia
		media-fonts/lohit-tamil
		media-fonts/lohit-tamil-classical
		media-fonts/lohit-telugu
		media-fonts/nanum
		media-fonts/fonts-noto-cjk
		media-fonts/noto-emoji
		media-fonts/sil-abyssinica
		media-fonts/sil-padauk
		media-fonts/stix-fonts
		media-fonts/symbola
		media-fonts/takao-fonts
		media-fonts/thaifonts-scalable
		media-fonts/tibetan-machine-font
		media-fonts/urw-fonts )
	games? (
		=games-board/gnome-mahjongg-3.22*
		=games-board/gnome-mines-3.30*
		=games-puzzle/gnome-sudoku-3.30* )
	utils? (
		app-admin/gnome-system-log
		app-backup/deja-dup[nautilus]
		=app-arch/file-roller-${GVER}
		=app-crypt/seahorse-${GVER}
		=app-editors/gedit-${GVER}
		=app-text/evince-3.32*
		=gnome-extra/gnome-calculator-${GVER}
		=gnome-extra/gnome-calendar-${GVER}
		=gnome-extra/gnome-power-manager-3.30*
		=gnome-extra/gnome-system-monitor-${GVER}
		gnome-extra/gucharmap:2.90
		=gnome-extra/yelp-${GVER}
		=media-gfx/eog-3.28*
		=media-gfx/gnome-font-viewer-${GVER}
		=media-gfx/gnome-screenshot-${GVER}
		=media-gfx/simple-scan-${GVER}
		=media-video/cheese-${GVER}
		net-misc/remmina
		=net-misc/vino-3.22*
		net-p2p/transmission[ayatana]
		=sys-apps/baobab-3.30*
		=sys-apps/gnome-disk-utility-${GVER}
		unity-indicators/indicator-keyboard[charmap]
		unity-indicators/indicator-power[powerman]
		=x11-terms/gnome-terminal-${GVER} )
	xdm? ( || ( unity-extra/unity-greeter gnome-base/gdm ) )"
