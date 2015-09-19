# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{3_3,3_4} )

inherit distutils-r1 fdo-mime gnome2-utils ubuntu-versionator

URELEASE="wily"
UURL="mirror://ubuntu/pool/universe/u/${PN}"

DESCRIPTION="Configuration manager for the Unity desktop environment"
HOMEPAGE="https://launchpad.net/unity-tweak-tool"
SRC_URI="${UURL}/${MY_P}${UVER}${UVER_PREFIX}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="nls"
RESTRICT="mirror"

RDEPEND="dev-libs/glib:2
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	dev-libs/libunity-webapps
	dev-util/intltool
	gnome-base/gsettings-desktop-schemas
	gnome-base/nautilus
	sys-devel/gettext
	unity-base/compiz
	unity-base/hud
	unity-base/overlay-scrollbar
	unity-base/unity
	unity-base/unity-settings-daemon
	unity-indicators/indicator-bluetooth
	unity-indicators/indicator-datetime
	unity-indicators/indicator-power
	unity-indicators/indicator-session
	unity-indicators/indicator-sound
	unity-lenses/unity-lens-applications
	unity-lenses/unity-lens-files
	virtual/pkgconfig
	x11-misc/notify-osd
	${PYTHON_DEPS}"

S="${WORKDIR}/utt"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	gnome2_environment_reset
}

src_prepare() {
	# Make Unity Tweak Tool appear in unity-control-center #
	sed -e 's:Categories=.*:Categories=Settings;X-GNOME-Settings-Panel;X-GNOME-PersonalSettings;X-Unity-Settings-Panel;:' \
		-e 's:Exec=.*:Exec=unity-tweak-tool:' \
		-e '/Actions=/{:a;n;/^$/!ba;i\X-Unity-Settings-Panel=unitytweak' -e '}' \
			-i unity-tweak-tool.desktop.in || die

	# Include /usr/share/cursors/xorg-x11/ in the paths to check for cursor themes as Gentoo #
	#  installs cursor themes in both /usr/share/cursors/xorg-x11/ and /usr/share/icons/ #
	epatch -p1 "${FILESDIR}/xorg-cursor-themes-path.diff"

	# Fix show/hide mounted drive icons (LP# 1372046) #
	epatch -p1 "${FILESDIR}/show-hide_mounted_drive_icons.diff"
}

src_install() {
	distutils-r1_src_install

	exeinto /etc/X11/xinit/xinitrc.d
	doexe "${FILESDIR}/95-xcursor-theme"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
}
