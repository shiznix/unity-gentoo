# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit ubuntu-versionator

DESCRIPTION="Unity Desktop - merge this to pull in all Unity packages"
HOMEPAGE="http://unity.ubuntu.com/"

URELEASE="jammy"

LICENSE="metapackage"
SLOT="0/${URELEASE}"
KEYWORDS="~amd64 ~x86"
IUSE="+accessibility +apps chat extras +fonts +games +utils +xdm"
RESTRICT="mirror"

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
	x11-misc/notify-osd
	x11-themes/ubuntu-wallpapers

	accessibility? (
		app-accessibility/at-spi2-atk
		app-accessibility/at-spi2-core
		app-accessibility/onboard
		app-accessibility/orca )
	apps? (
		|| ( app-office/libreoffice app-office/libreoffice-bin )
		|| ( mail-client/thunderbird mail-client/thunderbird-bin mail-client/evolution )
		media-gfx/shotwell
		media-sound/rhythmbox
		media-video/totem
		|| ( www-client/firefox www-client/firefox-bin www-client/chromium ) )
	chat? ( || (
		( net-im/pidgin x11-plugins/pidgin-libnotify )
		( net-im/empathy net-libs/telepathy-indicator )
		net-im/telegram-desktop net-im/telegram-desktop-bin ) )
	extras? (
		app-cdr/brasero
		gnome-base/dconf-editor
		sys-block/gparted
		unity-extra/unity-tweak-tool )
	fonts? (
		media-fonts/droid
		media-fonts/font-bitstream-type1
		media-fonts/fonts-noto-cjk
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
		media-fonts/noto-emoji
		media-fonts/quivira
		media-fonts/sil-abyssinica
		media-fonts/sil-padauk
		media-fonts/stix-fonts
		media-fonts/takao-fonts
		media-fonts/thaifonts-scalable
		media-fonts/tibetan-machine-font
		media-fonts/urw-fonts )
	games? (
		games-board/gnome-mahjongg
		games-board/gnome-mines
		games-puzzle/gnome-sudoku )
	utils? (
		amd64? ( app-backup/deja-dup )
		app-arch/file-roller
		app-crypt/seahorse
		app-editors/gedit
		app-text/evince
		gnome-extra/gnome-calculator
		gnome-extra/gnome-calendar
		gnome-extra/gnome-power-manager
		gnome-extra/gnome-system-monitor
		gnome-extra/gucharmap:2.90
		gnome-extra/yelp
		media-gfx/eog
		media-gfx/gnome-font-viewer
		media-gfx/gnome-screenshot
		media-gfx/simple-scan
		media-video/cheese
		net-misc/remmina
		net-p2p/transmission[appindicator]
		sys-apps/baobab
		sys-apps/gnome-disk-utility
		unity-base/unity-control-center[gnome-online-accounts]
		unity-indicators/indicator-keyboard[charmap]
		unity-indicators/indicator-power[powerman]
		x11-terms/gnome-terminal )
	xdm? ( || ( unity-extra/unity-greeter gnome-base/gdm ) )"
