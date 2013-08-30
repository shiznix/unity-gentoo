# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python3_2 )
DISTUTILS_NO_PARALLEL_BUILD=1

inherit distutils-r1 gnome2-utils ubuntu-versionator

URELEASE="raring-updates"
UURL="mirror://ubuntu/pool/universe/u/${PN}"

DESCRIPTION="Configuration manager for the Unity desktop environment"
HOMEPAGE="https://launchpad.net/unity-tweak-tool"
SRC_URI="${UURL}/${MY_P}${UVER}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="dev-libs/glib:2
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext"

S="${WORKDIR}/${PN}-${PV}${UVER}"
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
		distutils-r1_src_compile
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
