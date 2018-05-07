# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="bionic"
inherit gnome2-utils ubuntu-versionator

UVER=

DESCRIPTION="Default settings for the Unity"
HOMEPAGE="https://launchpad.net/ubuntu/+source/ubuntu-settings"
SRC_URI="${UURL}/${MY_P}.tar.xz"

LICENSE="GPL-2+"
#KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+ubuntu-cursor +ubuntu-sounds"
RESTRICT="binchecks mirror strip"

DEPEND="media-fonts/ubuntu-font-family
        x11-themes/ubuntu-themes
        x11-themes/ubuntu-wallpapers
	ubuntu-cursor? ( x11-themes/vanilla-dmz-xcursors )
	ubuntu-sounds? ( x11-themes/ubuntu-sounds )"

src_prepare() {
	ubuntu-versionator_src_prepare

	gschema="debian/ubuntu-settings.gsettings-override"

	if use ubuntu-cursor; then
		sed -e "/cursor-theme/{s/DMZ-White/Vanilla-DMZ/}" \
			-i "${gschema}"
	else
		sed -e "/cursor-theme/d" \
			-i "${gschema}"
	fi

	if ! use ubuntu-sounds; then
		sed -e "/org.gnome.desktop.sound/,+2 d" \
			-i "${gschema}"
	fi

	sed -e "/org.gnome.crypto.pgp/,+2 d" \
		-e "/picture-uri/{s/warty-final-ubuntu.png/contest\/${URELEASE}.xml/}" \
		-e "/session-name/{s/ubuntu/unity/}" \
		-e "/org.gnome.Epiphany/,+3 d" \
		-e "/org.gnome.login-screen/,+2 d" \
		-e "/org.gnome.mutter/,+6 d" \
		-e "/org.gnome.rhythmbox.encoding-settings/,+2 d" \
		-e "/org.gnome.shell/,+3 d" \
		-e "/org.gnome.software/,+2 d" \
		-e "s/:ubuntu\|:Unity//g" \
		-i "${gschema}"
}

src_install() {
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
	fi

	insinto /usr/share/glib-2.0/schemas
	newins "${gschema}" \
		10_ubuntu-settings.gschema.override
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
