# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_SINGLE_IMPL=1

URELEASE="kinetic"
inherit distutils-r1 eutils ubuntu-versionator

DESCRIPTION="MATE desktop tweak tool"
HOMEPAGE="https://github.com/ubuntu-mate/mate-tweak"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""

# Let people emerge this by default, bug #472932
#IUSE+=" +python_single_target_python3_7 python_single_target_python3_8"
RESTRICT="mirror"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
	')
	gnome-base/dconf
	gnome-extra/zenity
	mate-base/mate
	mate-extra/brisk-menu
	mate-extra/mate-hud
	mate-extra/mate-indicator-applet
	mate-extra/mate-media
	mate-extra/mate-menu
	mate-extra/mate-netbook
	mate-extra/ubuntu-mate-settings
	unity-base/compiz
	unity-indicators/ayatana-indicator-application
	unity-indicators/indicator-application
	unity-indicators/indicator-messages
	unity-indicators/indicator-power
	unity-indicators/indicator-session
	unity-indicators/indicator-sound
	x11-apps/mesa-progs
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/topmenu-gtk[mate]
	x11-wm/metacity
	x11-misc/mate-dock-applet
	x11-misc/plank
	x11-misc/vala-panel-appmenu[mate]
	x11-misc/xcompmgr
	x11-terms/tilda
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare

	## Correct paths in mate-tweak script ##
	sed -e "s:brisk-menu/brisk-menu:brisk-menu:g" \
		-e "s:/usr/lib/mate-netbook/mate-window-picker-applet:/usr/libexec/mate-window-picker-applet:g" \
		-e "s:/usr/lib/MULTIARCH:MULTIARCH:g" \
		-e "s:'/usr/lib/' + self.multiarch + :self.multiarch + :g" \
		-e "/self.multiarch = sysconfig.get_config_var/c\        self.multiarch = os.path.join('/','usr','libexec')" \
		-e "s:self.multiarch + '/mate-panel/libappmenu-mate.so':'/usr/$(get_libdir)/mate-panel/libappmenu-mate.so':g" \
			-i mate-tweak || die
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	python_fix_shebang "${ED}"
}
