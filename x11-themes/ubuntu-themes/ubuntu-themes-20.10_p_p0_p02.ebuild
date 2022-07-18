# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="jammy"
inherit eutils gnome2-utils ubuntu-versionator xdg-utils

DESCRIPTION="Monochrome icons for the Unity desktop (default icon theme)"
HOMEPAGE="https://launchpad.net/ubuntu-themes"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+nemo"
RESTRICT="mirror"

RDEPEND="!x11-themes/light-themes
	x11-themes/hicolor-icon-theme"

DEPEND="${RDEPEND}
	unity-extra/ehooks
	x11-misc/icon-naming-utils
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

PDEPEND="nemo? ( gnome-extra/nemo )"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"	# This needs to be applied for the debian/ directory to be present #
	ubuntu-versionator_src_prepare

	## set eog fullscreen toolbar background ##
	echo -e "\n/* eog fullscreen toolbar background */\noverlay > revealer > box > toolbar {\n background-color: @bg_color;\n}" >> Ambiance/gtk-3.20/gtk-widgets.css

	## tweak transmission-gtk progress bar border when selected ##
	echo -e "\n/* transmission-gtk progress bar border */\nwindow.background > box.vertical > scrolledwindow.tr-workarea > treeview.view:focus .progressbar:selected:not(:backdrop) {\n border-color: @selected_fg_color;\n}" >> Ambiance/gtk-3.20/gtk-widgets.css

	## tweak nautilus selection and search bar ##
	echo $(<"${FILESDIR}"/nautilus.css) >> Ambiance/gtk-3.20/apps/nautilus.css

	## fix nautilus properties window background ##
	echo -e "\n/* nautilus properties window background */window.background.unified:dir(ltr) > deck:dir(ltr) > box.vertical.view:dir(ltr) {\n background-color: transparent;\n}" >> Ambiance/gtk-3.20/gtk-widgets.css

	if portageq has_version / unity-extra/ehooks[headerbar_adjust]; then

		## workaround to avoid unwanted black frame when using HdyHeaderBar ##
		sed -i \
			-e "s/^decoration {$/.background.csd decoration {/" \
			Ambiance/gtk-3.20/gtk-widgets.css

		## remove HdyHeaderBar rounded top corners ##
		echo -e "\n/* HdyHeaderBar top corners */\n.background:not(.tiled):not(.maximized):not(.solid-csd) headerbar.titlebar {\n border-top-left-radius: 0;\n border-top-right-radius: 0;\n}" >> Ambiance/gtk-3.20/gtk-widgets.css
	fi

	use nemo && echo $(<"${FILESDIR}"/nemo.css) >> Ambiance/gtk-3.20/apps/nemo.css
}

src_configure() { :; }

src_compile() {
	emake
}

src_install() {
	## Install icons ##
	insinto /usr/share/icons
	doins -r LoginIcons ubuntu-mono-dark ubuntu-mono-light

	## Add customized drop-down menu icon as "go-down-symbolic" ##
	##   from Adwaita theme is too dark since v3.30 ##
	doins -r "${FILESDIR}"/drop-down-icon/*

	insinto /usr/share/icons/suru
	doins -r suru-icons/*

	## Install themes ##
	insinto /usr/share/themes
	doins -r Ambiance Radiance ubuntu-mobile

	## Remove broken symlinks ##
	find -L "${ED}" -type l -exec rm {} +
}

pkg_postinst() { xdg_icon_cache_update; }

pkg_postrm() { xdg_icon_cache_update; }
