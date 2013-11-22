# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python3_{2,3} )

inherit distutils-r1 fdo-mime gnome2-utils ubuntu-versionator

URELEASE="trusty"
UURL="mirror://ubuntu/pool/universe/u/${PN}"
UVER=

DESCRIPTION="Configuration manager for the Unity desktop environment"
HOMEPAGE="https://launchpad.net/unity-tweak-tool"
SRC_URI="${UURL}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="nls"
RESTRICT="mirror"

RDEPEND="dev-libs/glib:2
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	dev-libs/libunity-webapps
	dev-util/intltool
	dev-util/pkgconfig
	gnome-base/gnome-settings-daemon
	gnome-base/gsettings-desktop-schemas
	gnome-base/nautilus
	sys-devel/gettext
	unity-base/compiz
	unity-base/hud
	unity-base/overlay-scrollbar
	unity-base/unity
	unity-indicators/indicator-bluetooth
	unity-indicators/indicator-datetime
	unity-indicators/indicator-power
	unity-indicators/indicator-session
	unity-indicators/indicator-sound
	unity-lenses/unity-lens-applications
	unity-lenses/unity-lens-files
	x11-misc/notify-osd"

S="${WORKDIR}/${PN}"
USER_ID="$(id -u)"

src_prepare() {
	# Make Unity Tweak Tool appear in gnome-control-center #
	sed -e 's:Categories=.*:Categories=Settings;X-GNOME-Settings-Panel;X-GNOME-PersonalSettings;:' \
		-e 's:Exec=.*:Exec=unity-tweak-tool:' \
		-e '/Actions=/{:a;n;/^$/!ba;i\X-GNOME-Settings-Panel=unitytweak' -e '}' \
			-i unity-tweak-tool.desktop.in || die
}

src_compile() {
	## Sandbox violations caused when dev-python/python-distutils-extra's build system tries to start an Xsession and fails but as part ##
	##  of that also tries to start /usr/libexec/dconf-service if it's not already running which causes dconf sandbox violations ##
		addpredict /run/user/$USER_ID/dconf
		addpredict $XDG_RUNTIME_DIR/dconf
		distutils-r1_src_compile
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
