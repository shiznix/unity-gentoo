# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="cosmic"
inherit gnome2-utils

DESCRIPTION="Default settings for the Unity"
HOMEPAGE="https://launchpad.net/ubuntu/+source/ubuntu-settings"
SRC_URI=""

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+ubuntu-cursor +ubuntu-sounds"

DEPEND=""
RDEPEND="media-fonts/ubuntu-font-family
	x11-themes/ubuntu-themes
	x11-themes/ubuntu-wallpapers
	ubuntu-cursor? ( x11-themes/vanilla-dmz-xcursors )
	ubuntu-sounds? ( x11-themes/ubuntu-sounds )"

S="${FILESDIR}"

src_install() {
	local \
		gschema="10_ubuntu-settings.gschema.override" \
		gschema_dir="/usr/share/glib-2.0/schemas"

	insinto "${gschema_dir}"
	newins "${FILESDIR}"/ubuntu-settings.gsettings-override \
		"${gschema}"

	if use ubuntu-cursor; then
		# Do the following only if there #
		#  is no file collision detected #
		local index_dir="/usr/share/cursors/xorg-x11/default"
		[[ -e "${EROOT%/}${index_dir}"/index.theme ]] \
			&& local index_owner=$(portageq owners "${EROOT}" "${EROOT%/}${index_dir}"/index.theme 2>/dev/null | grep "${CATEGORY}/${PN}-[0-9]" 2>/dev/null)
		## pass when not null or unset
		if [[ -n "${index_owner-unset}" ]]; then
			insinto "${index_dir}"
			doins "${FILESDIR}"/index.theme
		fi
	else
		sed -i \
			-e "/cursor-theme/d" \
			"${ED}${gschema_dir}/${gschema}"
	fi

	! use ubuntu-sounds && sed -i \
		-e "/org.gnome.desktop.sound/,+2 d" \
		"${ED}${gschema_dir}/${gschema}"

	sed -i \
		-e "/picture-uri/{s/warty-final-ubuntu.png/contest\/${URELEASE/-*}.xml/}" \
		"${ED}${gschema_dir}/${gschema}"
}

pkg_preinst() {
	# Modified gnome2_schemas_savelist to find *.gschema.override files #
	export GNOME2_ECLASS_GLIB_SCHEMAS=$(find "${ED}usr/share/glib-2.0/schemas" -name "*.gschema.override" 2>/dev/null)
}

pkg_postinst() {
        gnome2_schemas_update
}

pkg_postrm() {
        gnome2_schemas_update
}
